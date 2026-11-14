import React, { useState, useEffect } from 'react';
import {
  LayoutDashboard,
  Sparkles,
  Calendar,
  Share2,
  Search,
  BookOpen,
  Users,
  Cpu,
  Settings,
  AlertTriangle,
  CheckCircle2,
  Play,
  Pause,
  ExternalLink,
  RefreshCw,
  Image as ImageIcon,
  Flame,
  ArrowUpRight,
  ShieldCheck,
  Instagram,
  Linkedin,
  FileText,
  Mail,
  TrendingUp,
  History,
  Activity,
  Plus,
  Send,
  Eye,
  Trash2,
  Database
} from 'lucide-react';

interface DatabaseStatus {
  status: string;
  database: string;
  host: string;
  port: number;
  server_version: string;
  data_directory: string;
  total_tables: number;
  last_successful_connection: string | null;
  latest_database_error: string | null;
  engine: string;
}

interface StatsOverview {
  posts: { total_posts: number; published: number; scheduled: number; ready: number; drafted: number };
  leads: { total_leads: number; hot_leads: number; warm_leads: number };
  seo: { total_keywords: number };
  blogs: { total_blogs: number };
  publishing: { total_logs: number; successful_publishes: number };
}

interface ContentItem {
  id: number;
  content_id: string;
  topic: string;
  platform: string;
  content_category: string;
  caption: string;
  hashtags: string;
  image_url: string;
  cta: string;
  scheduled_at: string;
  approval_status: string;
  publishing_status: string;
}

interface LeadItem {
  id: number;
  full_name: string;
  email: string;
  phone?: string;
  company: string;
  industry: string;
  lead_score: number;
  category: string;
  status: string;
  notes: string;
}

interface WorkflowItem {
  id: number;
  workflow_code: string;
  name: string;
  is_active: boolean;
  trigger_schedule: string;
  status: string;
}

interface KeywordItem {
  id: number;
  keyword: string;
  search_intent: string;
  monthly_volume: number;
  difficulty: string;
  priority: string;
  status: string;
}

interface BlogItem {
  id: number;
  title: string;
  slug: string;
  meta_description: string;
  markdown_content: string;
  faq_schema_json: string;
  status: string;
  published_url: string;
}

interface CompetitorData {
  competitors: Array<{ id: number; name: string; website: string; notes: string }>;
  activity: Array<{ id: number; title: string; content_summary: string; source_url: string }>;
}

interface CampaignData {
  campaigns: Array<{ id: number; name: string; subject_line: string; status: string; created_at: string }>;
  subscribers: number;
}

interface PublishingLog {
  id: number;
  topic: string;
  platform: string;
  post_url: string;
  status: string;
  published_at: string;
}

interface SystemLog {
  id: number;
  level: string;
  source: string;
  message: string;
  created_at: string;
}

export default function App() {
  const [activeTab, setActiveTab] = useState<
    'overview' | 'factory' | 'calendar' | 'instagram' | 'linkedin' | 'seo' | 'blogs' | 'leads' | 'competitors' | 'email' | 'analytics' | 'history' | 'workflows' | 'logs' | 'settings'
  >('overview');

  const [stats, setStats] = useState<StatsOverview | null>(null);
  const [contentList, setContentList] = useState<ContentItem[]>([]);
  const [leadsList, setLeadsList] = useState<LeadItem[]>([]);
  const [workflowsList, setWorkflowsList] = useState<WorkflowItem[]>([]);
  const [keywordsList, setKeywordsList] = useState<KeywordItem[]>([]);
  const [blogsList, setBlogsList] = useState<BlogItem[]>([]);
  const [compData, setCompData] = useState<CompetitorData>({ competitors: [], activity: [] });
  const [campaignData, setCampaignData] = useState<CampaignData>({ campaigns: [], subscribers: 0 });
  const [pubLogs, setPubLogs] = useState<PublishingLog[]>([]);
  const [sysLogs, setSysLogs] = useState<SystemLog[]>([]);
  const [settings, setSettings] = useState<Record<string, string>>({});
  const [dbStatus, setDbStatus] = useState<DatabaseStatus | null>(null);
  const [loading, setLoading] = useState(false);

  // Content Generation Form
  const [genTopic, setGenTopic] = useState('');
  const [genPlatform, setGenPlatform] = useState('LinkedIn');
  const [genCategory, setGenCategory] = useState('Technical');
  const [generating, setGenerating] = useState(false);
  const [lastGenerated, setLastGenerated] = useState<any>(null);

  // Lead Intake Form
  const [leadName, setLeadName] = useState('');
  const [leadEmail, setLeadEmail] = useState('');
  const [leadCompany, setLeadCompany] = useState('');
  const [leadMessage, setLeadMessage] = useState('');
  const [leadSubmitting, setLeadSubmitting] = useState(false);

  // SEO Form
  const [newKeyword, setNewKeyword] = useState('');
  const [newIntent, setNewIntent] = useState('Commercial');
  const [blogGenerating, setBlogGenerating] = useState(false);

  // Competitor Form
  const [compName, setCompName] = useState('');
  const [compSite, setCompSite] = useState('');
  const [compNotes, setCompNotes] = useState('');

  // Selected Blog View
  const [selectedBlog, setSelectedBlog] = useState<BlogItem | null>(null);

  const fetchAllData = async () => {
    try {
      setLoading(true);
      const [rStats, rContent, rLeads, rWf, rKeywords, rBlogs, rComp, rCamp, rLogs, rSysLogs, rSet, rDb] = await Promise.all([
        fetch('/api/analytics/overview').then(r => r.json()).catch(() => null),
        fetch('/api/content').then(r => r.json()).catch(() => []),
        fetch('/api/leads').then(r => r.json()).catch(() => []),
        fetch('/api/workflows').then(r => r.json()).catch(() => []),
        fetch('/api/seo/keywords').then(r => r.json()).catch(() => []),
        fetch('/api/blogs').then(r => r.json()).catch(() => []),
        fetch('/api/competitors').then(r => r.json()).catch(() => ({ competitors: [], activity: [] })),
        fetch('/api/campaigns').then(r => r.json()).catch(() => ({ campaigns: [], subscribers: 0 })),
        fetch('/api/publishing/logs').then(r => r.json()).catch(() => []),
        fetch('/api/logs').then(r => r.json()).catch(() => []),
        fetch('/api/settings').then(r => r.json()).catch(() => ({})),
        fetch('/api/database/status').then(r => r.json()).catch(() => null)
      ]);

      if (rStats) setStats(rStats);
      if (Array.isArray(rContent)) setContentList(rContent);
      if (Array.isArray(rLeads)) setLeadsList(rLeads);
      if (Array.isArray(rWf)) setWorkflowsList(rWf);
      if (Array.isArray(rKeywords)) setKeywordsList(rKeywords);
      if (Array.isArray(rBlogs)) setBlogsList(rBlogs);
      if (rComp) setCompData(rComp);
      if (rCamp) setCampaignData(rCamp);
      if (Array.isArray(rLogs)) setPubLogs(rLogs);
      if (Array.isArray(rSysLogs)) setSysLogs(rSysLogs);
      if (rSet) setSettings(rSet);
      if (rDb) setDbStatus(rDb);
    } catch (e) {
      console.error('Error fetching dashboard data:', e);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchAllData();
  }, []);

  const handleGenerateContent = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!genTopic) return;
    setGenerating(true);
    try {
      const res = await fetch('/api/content/generate', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          topic: genTopic,
          platform: genPlatform,
          category: genCategory
        })
      });
      const data = await res.json();
      setLastGenerated(data);
      setGenTopic('');
      fetchAllData();
    } catch (err) {
      alert('Generation error: ' + err);
    } finally {
      setGenerating(false);
    }
  };

  const handleApprove = async (id: number, status: 'APPROVED' | 'REJECTED') => {
    try {
      await fetch('/api/content/approve', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ calendar_id: id, status })
      });
      fetchAllData();
    } catch (err) {
      alert('Approval error: ' + err);
    }
  };

  const handlePublishNow = async (id: number) => {
    try {
      const res = await fetch('/api/publishing/publish-now', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ calendar_id: id })
      });
      const data = await res.json();
      alert(`Published successfully! URL: ${data.published_url}`);
      fetchAllData();
    } catch (err) {
      alert('Publish error: ' + err);
    }
  };

  const handleDeleteContent = async (id: number) => {
    if (!confirm('Are you sure you want to delete this post?')) return;
    try {
      await fetch(`/api/content/${id}`, { method: 'DELETE' });
      fetchAllData();
    } catch (err) {
      alert('Delete error: ' + err);
    }
  };

  const handleLeadSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!leadEmail || !leadName) return;
    setLeadSubmitting(true);
    try {
      const res = await fetch('/api/leads/intake', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          full_name: leadName,
          email: leadEmail,
          company: leadCompany,
          message: leadMessage
        })
      });
      const data = await res.json();
      setLeadName('');
      setLeadEmail('');
      setLeadCompany('');
      setLeadMessage('');
      alert(`Lead Scored by AI: ${data.lead_score}/100 [${data.category}]\nAction: ${data.recommended_action}`);
      fetchAllData();
    } catch (err) {
      alert('Lead intake error: ' + err);
    } finally {
      setLeadSubmitting(false);
    }
  };

  const handleAddKeyword = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!newKeyword) return;
    try {
      await fetch('/api/seo/keywords', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ keyword: newKeyword, search_intent: newIntent, priority: 'HIGH' })
      });
      setNewKeyword('');
      fetchAllData();
    } catch (err) {
      alert('Error adding keyword: ' + err);
    }
  };

  const handleGenerateBlog = async (keyword: string) => {
    setBlogGenerating(true);
    try {
      const res = await fetch('/api/blogs/generate', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ keyword })
      });
      const data = await res.json();
      alert(`Blog generated: "${data.title}"\nSaved as draft at: ${data.url}`);
      fetchAllData();
    } catch (err) {
      alert('Blog generation error: ' + err);
    } finally {
      setBlogGenerating(false);
    }
  };

  const handleAddCompetitor = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!compName || !compSite) return;
    try {
      await fetch('/api/competitors', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ name: compName, website: compSite, notes: compNotes })
      });
      setCompName('');
      setCompSite('');
      setCompNotes('');
      fetchAllData();
    } catch (err) {
      alert('Competitor error: ' + err);
    }
  };

  const handleGenerateNewsletter = async () => {
    try {
      const res = await fetch('/api/campaigns/generate', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          blog_title: 'Accelerating Indian Enterprises with Practical AI Automation',
          tip_topic: 'Eliminating Inventory Spreadsheet Errors'
        })
      });
      const data = await res.json();
      alert(`Newsletter campaign generated: "${data.subject_line}"`);
      fetchAllData();
    } catch (err) {
      alert('Newsletter error: ' + err);
    }
  };

  const handleTriggerReport = async () => {
    try {
      const res = await fetch('/api/analytics/report', { method: 'POST' });
      const data = await res.json();
      alert(`Marketing Report Generated! ID: ${data.report_id}`);
      fetchAllData();
    } catch (err) {
      alert('Report error: ' + err);
    }
  };

  const toggleAutoPublish = async () => {
    const current = settings['AUTO_PUBLISH'] === 'TRUE';
    const nextVal = current ? 'FALSE' : 'TRUE';
    await fetch('/api/settings', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ setting_key: 'AUTO_PUBLISH', setting_value: nextVal })
    });
    fetchAllData();
  };

  const toggleEmergencyKill = async () => {
    const current = settings['EMERGENCY_KILL_SWITCH'] === 'TRUE';
    const nextVal = current ? 'FALSE' : 'TRUE';
    await fetch('/api/settings', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ setting_key: 'EMERGENCY_KILL_SWITCH', setting_value: nextVal })
    });
    fetchAllData();
  };

  return (
    <div style={{ display: 'flex', minHeight: '100vh', background: '#060a12' }}>
      {/* Sidebar */}
      <aside style={{ width: '270px', borderRight: '1px solid rgba(30, 48, 80, 0.6)', background: 'rgba(10, 16, 28, 0.95)', padding: '24px 16px', display: 'flex', flexDirection: 'column', gap: '8px' }}>
        <div style={{ padding: '0 12px 20px 12px', borderBottom: '1px solid rgba(30, 48, 80, 0.6)' }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: '10px' }}>
            <div style={{ width: '38px', height: '38px', borderRadius: '10px', background: 'linear-gradient(135deg, #00f2fe, #9b51e0)', display: 'flex', alignItems: 'center', justifyContent: 'center', fontWeight: '800', color: '#070b14', fontSize: '18px' }}>
              Z
            </div>
            <div>
              <h1 style={{ fontSize: '18px', fontWeight: '800', letterSpacing: '-0.5px', color: '#f8fafc' }}>
                Zet<span style={{ color: '#00f2fe' }}>Hub</span>
              </h1>
              <span style={{ fontSize: '11px', color: '#94a3b8', textTransform: 'uppercase', letterSpacing: '1px' }}>Marketing OS</span>
            </div>
          </div>
        </div>

        <nav style={{ display: 'flex', flexDirection: 'column', gap: '3px', marginTop: '10px', overflowY: 'auto', paddingRight: '4px' }}>
          {[
            { id: 'overview', label: 'Overview', icon: LayoutDashboard },
            { id: 'factory', label: 'AI Content Factory', icon: Sparkles },
            { id: 'calendar', label: 'Content Calendar', icon: Calendar },
            { id: 'instagram', label: 'Instagram Studio', icon: Instagram },
            { id: 'linkedin', label: 'LinkedIn Studio', icon: Linkedin },
            { id: 'seo', label: 'Website & SEO', icon: Search },
            { id: 'blogs', label: 'Blog Manager', icon: BookOpen },
            { id: 'leads', label: 'Leads & CRM', icon: Users },
            { id: 'competitors', label: 'Competitor Radar', icon: Activity },
            { id: 'email', label: 'Email Marketing', icon: Mail },
            { id: 'analytics', label: 'Analytics & Reports', icon: TrendingUp },
            { id: 'history', label: 'Publishing History', icon: History },
            { id: 'workflows', label: 'Workflows (10)', icon: Cpu },
            { id: 'logs', label: 'System Diagnostics', icon: ShieldCheck },
            { id: 'settings', label: 'Settings & Policy', icon: Settings },
          ].map(item => {
            const Icon = item.icon;
            const active = activeTab === item.id;
            return (
              <button
                key={item.id}
                onClick={() => setActiveTab(item.id as any)}
                style={{
                  display: 'flex',
                  alignItems: 'center',
                  gap: '10px',
                  padding: '10px 12px',
                  borderRadius: '10px',
                  border: 'none',
                  background: active ? 'rgba(0, 242, 254, 0.12)' : 'transparent',
                  color: active ? '#00f2fe' : '#94a3b8',
                  fontWeight: active ? '700' : '500',
                  fontSize: '13px',
                  cursor: 'pointer',
                  textAlign: 'left',
                  transition: 'all 0.15s ease'
                }}
              >
                <Icon size={16} />
                {item.label}
              </button>
            );
          })}
        </nav>

        <div style={{ marginTop: 'auto', padding: '14px', background: 'rgba(18, 28, 50, 0.5)', borderRadius: '12px', border: '1px solid rgba(40, 60, 95, 0.4)' }}>
          <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: '6px' }}>
            <span style={{ fontSize: '11px', color: '#94a3b8' }}>Vireonix AI (auto)</span>
            <span style={{ width: '8px', height: '8px', borderRadius: '50%', background: '#34d399', boxShadow: '0 0 8px #34d399' }}></span>
          </div>
          <div style={{ fontSize: '11px', color: '#cbd5e1' }}>DB: <span style={{ color: '#34d399', fontWeight: '600' }}>MySQL 3306</span></div>
          <div style={{ fontSize: '11px', color: '#cbd5e1' }}>Render: <span style={{ color: '#00f2fe', fontWeight: '600' }}>:5001</span></div>
        </div>
      </aside>

      {/* Main Content Area */}
      <main style={{ flex: 1, display: 'flex', flexDirection: 'column', height: '100vh', overflowY: 'auto' }}>
        {/* Top Header */}
        <header style={{ padding: '14px 28px', borderBottom: '1px solid rgba(30, 48, 80, 0.6)', background: 'rgba(10, 16, 28, 0.85)', backdropFilter: 'blur(10px)', display: 'flex', alignItems: 'center', justifyContent: 'space-between', position: 'sticky', top: 0, zIndex: 10 }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: '14px' }}>
            <div style={{ display: 'flex', alignItems: 'center', gap: '6px', padding: '6px 12px', borderRadius: '20px', background: 'rgba(25, 40, 70, 0.6)', border: '1px solid rgba(50, 75, 120, 0.5)' }}>
              <span style={{ fontSize: '11px', color: '#94a3b8' }}>Mode:</span>
              <span style={{ fontSize: '12px', fontWeight: '700', color: '#00f2fe' }}>{settings['OPERATING_MODE'] || 'APPROVAL'}</span>
            </div>

            <button
              onClick={toggleAutoPublish}
              style={{
                display: 'flex',
                alignItems: 'center',
                gap: '6px',
                padding: '6px 12px',
                borderRadius: '20px',
                border: '1px solid',
                fontSize: '12px',
                fontWeight: '600',
                cursor: 'pointer',
                background: settings['AUTO_PUBLISH'] === 'TRUE' ? 'rgba(16, 185, 129, 0.15)' : 'rgba(245, 158, 11, 0.15)',
                color: settings['AUTO_PUBLISH'] === 'TRUE' ? '#34d399' : '#fbbf24',
                borderColor: settings['AUTO_PUBLISH'] === 'TRUE' ? 'rgba(16, 185, 129, 0.4)' : 'rgba(245, 158, 11, 0.4)'
              }}
            >
              {settings['AUTO_PUBLISH'] === 'TRUE' ? <Play size={12} /> : <Pause size={12} />}
              Auto-Publish: {settings['AUTO_PUBLISH'] === 'TRUE' ? 'ENABLED' : 'PAUSED'}
            </button>
          </div>

          <div style={{ display: 'flex', alignItems: 'center', gap: '12px' }}>
            <button
              onClick={toggleEmergencyKill}
              className="btn-danger"
              style={{
                display: 'flex',
                alignItems: 'center',
                gap: '6px',
                background: settings['EMERGENCY_KILL_SWITCH'] === 'TRUE' ? '#ef4444' : 'rgba(239, 68, 68, 0.15)',
                color: settings['EMERGENCY_KILL_SWITCH'] === 'TRUE' ? '#ffffff' : '#f87171'
              }}
            >
              <AlertTriangle size={14} />
              {settings['EMERGENCY_KILL_SWITCH'] === 'TRUE' ? 'KILL SWITCH ACTIVE' : 'Emergency Stop'}
            </button>

            <button onClick={fetchAllData} className="btn-secondary" style={{ padding: '8px 12px' }}>
              <RefreshCw size={14} className={loading ? 'animate-spin' : ''} />
            </button>
          </div>
        </header>

        {/* Tab Views */}
        <div style={{ padding: '28px', display: 'flex', flexDirection: 'column', gap: '28px' }}>
          {/* TAB 1: OVERVIEW */}
          {activeTab === 'overview' && (
            <>
              {/* Stat Cards */}
              <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(200px, 1fr))', gap: '16px' }}>
                <div className="glass-panel" style={{ padding: '18px' }}>
                  <div style={{ fontSize: '12px', color: '#94a3b8', marginBottom: '6px' }}>Total Posts Planned</div>
                  <div style={{ fontSize: '26px', fontWeight: '800', color: '#f8fafc' }}>{stats?.posts?.total_posts || 0}</div>
                  <div style={{ fontSize: '11px', color: '#34d399', marginTop: '4px' }}>{stats?.posts?.ready || 0} Ready | {stats?.posts?.scheduled || 0} Scheduled</div>
                </div>

                <div className="glass-panel" style={{ padding: '18px' }}>
                  <div style={{ fontSize: '12px', color: '#94a3b8', marginBottom: '6px' }}>Inbound CRM Leads</div>
                  <div style={{ fontSize: '26px', fontWeight: '800', color: '#f8fafc' }}>{stats?.leads?.total_leads || 0}</div>
                  <div style={{ fontSize: '11px', color: '#f87171', marginTop: '4px', display: 'flex', alignItems: 'center', gap: '4px' }}>
                    <Flame size={13} /> {stats?.leads?.hot_leads || 0} Hot Prospects
                  </div>
                </div>

                <div className="glass-panel" style={{ padding: '18px' }}>
                  <div style={{ fontSize: '12px', color: '#94a3b8', marginBottom: '6px' }}>SEO Keywords & Blogs</div>
                  <div style={{ fontSize: '26px', fontWeight: '800', color: '#f8fafc' }}>{stats?.seo?.total_keywords || 0}</div>
                  <div style={{ fontSize: '11px', color: '#60a5fa', marginTop: '4px' }}>{stats?.blogs?.total_blogs || 0} Articles Drafted</div>
                </div>

                <div className="glass-panel" style={{ padding: '18px' }}>
                  <div style={{ fontSize: '12px', color: '#94a3b8', marginBottom: '6px' }}>Autonomous Workflows</div>
                  <div style={{ fontSize: '26px', fontWeight: '800', color: '#00f2fe' }}>10</div>
                  <div style={{ fontSize: '11px', color: '#34d399', marginTop: '4px' }}>Production n8n Active</div>
                </div>
              </div>

              {/* Central Database Status (XAMPP MySQL) */}
              <div className="glass-panel" style={{ padding: '18px 24px' }}>
                <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '14px' }}>
                  <div style={{ display: 'flex', alignItems: 'center', gap: '10px' }}>
                    <div style={{ background: 'linear-gradient(135deg, #4f46e5, #06b6d4)', padding: '8px', borderRadius: '8px' }}>
                      <Database size={18} color="#fff" />
                    </div>
                    <div>
                      <h2 style={{ fontSize: '16px', fontWeight: '800', color: '#f8fafc' }}>Central Database Status (XAMPP MySQL)</h2>
                      <div style={{ fontSize: '11px', color: '#94a3b8' }}>Real-time MariaDB health, connection telemetry & table registry</div>
                    </div>
                  </div>
                  <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
                    <span className={`badge ${dbStatus?.status === 'connected' ? 'badge-ready' : 'badge-hot'}`}>
                      {dbStatus?.status === 'connected' ? '● CONNECTED' : '● DISCONNECTED'}
                    </span>
                    <button onClick={fetchAllData} className="btn-secondary" style={{ padding: '4px 8px', fontSize: '11px' }}>
                      <RefreshCw size={11} /> Refresh
                    </button>
                  </div>
                </div>

                <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(180px, 1fr))', gap: '12px' }}>
                  <div className="glass-card" style={{ padding: '12px' }}>
                    <div style={{ fontSize: '11px', color: '#94a3b8' }}>Database Name</div>
                    <div style={{ fontSize: '14px', fontWeight: '700', color: '#00f2fe', fontFamily: 'JetBrains Mono' }}>{dbStatus?.database || 'zethub_marketing_os'}</div>
                    <div style={{ fontSize: '10px', color: '#64748b' }}>utf8mb4_unicode_ci</div>
                  </div>

                  <div className="glass-card" style={{ padding: '12px' }}>
                    <div style={{ fontSize: '11px', color: '#94a3b8' }}>Host & Port</div>
                    <div style={{ fontSize: '14px', fontWeight: '700', color: '#f8fafc', fontFamily: 'JetBrains Mono' }}>{dbStatus?.host}:{dbStatus?.port}</div>
                    <div style={{ fontSize: '10px', color: '#34d399' }}>Loopback (Secure Local)</div>
                  </div>

                  <div className="glass-card" style={{ padding: '12px' }}>
                    <div style={{ fontSize: '11px', color: '#94a3b8' }}>Server Engine</div>
                    <div style={{ fontSize: '14px', fontWeight: '700', color: '#a78bfa' }}>{dbStatus?.server_version || '10.4.32-MariaDB'}</div>
                    <div style={{ fontSize: '10px', color: '#64748b' }}>{dbStatus?.engine || 'XAMPP MariaDB'}</div>
                  </div>

                  <div className="glass-card" style={{ padding: '12px' }}>
                    <div style={{ fontSize: '11px', color: '#94a3b8' }}>Total Tables</div>
                    <div style={{ fontSize: '14px', fontWeight: '700', color: '#38bdf8' }}>{dbStatus?.total_tables || 26} Tables</div>
                    <div style={{ fontSize: '10px', color: '#34d399' }}>All Relational Schemas Active</div>
                  </div>

                  <div className="glass-card" style={{ padding: '12px' }}>
                    <div style={{ fontSize: '11px', color: '#94a3b8' }}>Last Active Ping</div>
                    <div style={{ fontSize: '12px', fontWeight: '600', color: '#e2e8f0' }}>{dbStatus?.last_successful_connection ? new Date(dbStatus.last_successful_connection).toLocaleTimeString() : 'Active'}</div>
                    <div style={{ fontSize: '10px', color: '#64748b' }}>Error: {dbStatus?.latest_database_error || 'None (Healthy)'}</div>
                  </div>
                </div>
              </div>

              {/* Quick Actions & Pipeline */}
              <div style={{ display: 'grid', gridTemplateColumns: '2fr 1fr', gap: '20px' }}>
                <div className="glass-panel" style={{ padding: '20px' }}>
                  <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '14px' }}>
                    <h2 style={{ fontSize: '17px', fontWeight: '700' }}>Recent Content Pipeline</h2>
                    <button onClick={() => setActiveTab('factory')} className="btn-primary" style={{ padding: '6px 12px', fontSize: '12px' }}>
                      <Sparkles size={13} /> Create Post
                    </button>
                  </div>

                  <div style={{ display: 'flex', flexDirection: 'column', gap: '10px' }}>
                    {contentList.slice(0, 5).map(item => (
                      <div key={item.id} className="glass-card" style={{ padding: '14px', display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                        <div>
                          <div style={{ display: 'flex', alignItems: 'center', gap: '6px', marginBottom: '4px' }}>
                            <span className="badge badge-active">{item.platform}</span>
                            <span style={{ fontSize: '11px', color: '#94a3b8' }}>{item.content_category}</span>
                            <span className={`badge ${item.publishing_status === 'READY' ? 'badge-ready' : (item.publishing_status === 'PUBLISHED' ? 'badge-active' : 'badge-draft')}`}>
                              {item.publishing_status}
                            </span>
                          </div>
                          <div style={{ fontSize: '13px', fontWeight: '600', color: '#f8fafc' }}>{item.topic}</div>
                        </div>

                        <div style={{ display: 'flex', gap: '6px' }}>
                          {item.approval_status === 'DRAFT' && (
                            <button onClick={() => handleApprove(item.id, 'APPROVED')} className="btn-primary" style={{ padding: '4px 10px', fontSize: '11px' }}>
                              Approve
                            </button>
                          )}
                          {item.approval_status === 'APPROVED' && item.publishing_status !== 'PUBLISHED' && (
                            <button onClick={() => handlePublishNow(item.id)} className="btn-secondary" style={{ padding: '4px 10px', fontSize: '11px' }}>
                              Publish Now
                            </button>
                          )}
                        </div>
                      </div>
                    ))}
                  </div>
                </div>

                <div className="glass-panel" style={{ padding: '20px' }}>
                  <h2 style={{ fontSize: '17px', fontWeight: '700', marginBottom: '14px' }}>Inbound CRM Activity</h2>
                  <div style={{ display: 'flex', flexDirection: 'column', gap: '10px' }}>
                    {leadsList.slice(0, 5).map(lead => (
                      <div key={lead.id} className="glass-card" style={{ padding: '12px' }}>
                        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '4px' }}>
                          <span style={{ fontSize: '13px', fontWeight: '700', color: '#f8fafc' }}>{lead.full_name}</span>
                          <span className={`badge ${lead.category === 'HOT' ? 'badge-hot' : 'badge-draft'}`}>
                            {lead.category} ({lead.lead_score})
                          </span>
                        </div>
                        <div style={{ fontSize: '11px', color: '#94a3b8' }}>{lead.company || lead.email}</div>
                        <div style={{ fontSize: '11px', color: '#34d399', marginTop: '4px' }}>{lead.notes}</div>
                      </div>
                    ))}
                  </div>
                </div>
              </div>
            </>
          )}

          {/* TAB 2: AI CONTENT FACTORY */}
          {activeTab === 'factory' && (
            <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '20px' }}>
              <div className="glass-panel" style={{ padding: '24px' }}>
                <h2 style={{ fontSize: '18px', fontWeight: '800', marginBottom: '6px', color: '#f8fafc' }}>
                  AI Content Factory <Sparkles size={16} style={{ display: 'inline', color: '#00f2fe' }} />
                </h2>
                <p style={{ fontSize: '12px', color: '#94a3b8', marginBottom: '20px' }}>
                  Vireonix AI generation + Strict Brand QA validation + High-Res Pillow graphic rendering.
                </p>

                <form onSubmit={handleGenerateContent} style={{ display: 'flex', flexDirection: 'column', gap: '16px' }}>
                  <div>
                    <label style={{ display: 'block', fontSize: '12px', fontWeight: '600', marginBottom: '6px', color: '#cbd5e1' }}>Content Topic</label>
                    <input
                      type="text"
                      placeholder="e.g. How AI workflow automation eliminates textile stockout errors"
                      value={genTopic}
                      onChange={e => setGenTopic(e.target.value)}
                      style={{ width: '100%', padding: '10px 12px', background: 'rgba(18, 28, 50, 0.8)', border: '1px solid rgba(40, 65, 110, 0.6)', borderRadius: '8px', color: '#fff', fontSize: '13px' }}
                      required
                    />
                  </div>

                  <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '12px' }}>
                    <div>
                      <label style={{ display: 'block', fontSize: '12px', fontWeight: '600', marginBottom: '6px', color: '#cbd5e1' }}>Platform</label>
                      <select
                        value={genPlatform}
                        onChange={e => setGenPlatform(e.target.value)}
                        style={{ width: '100%', padding: '10px 12px', background: 'rgba(18, 28, 50, 0.8)', border: '1px solid rgba(40, 65, 110, 0.6)', borderRadius: '8px', color: '#fff', fontSize: '13px' }}
                      >
                        <option value="LinkedIn">LinkedIn (1080x1080)</option>
                        <option value="Instagram">Instagram (1080x1350)</option>
                      </select>
                    </div>

                    <div>
                      <label style={{ display: 'block', fontSize: '12px', fontWeight: '600', marginBottom: '6px', color: '#cbd5e1' }}>Content Pillar</label>
                      <select
                        value={genCategory}
                        onChange={e => setGenCategory(e.target.value)}
                        style={{ width: '100%', padding: '10px 12px', background: 'rgba(18, 28, 50, 0.8)', border: '1px solid rgba(40, 65, 110, 0.6)', borderRadius: '8px', color: '#fff', fontSize: '13px' }}
                      >
                        <option value="Educational">Educational Guide</option>
                        <option value="Technical">Technical Architecture</option>
                        <option value="Product">ZetHub Product Feature</option>
                        <option value="Industry">Industry Trends / SMEs</option>
                      </select>
                    </div>
                  </div>

                  <button type="submit" disabled={generating} className="btn-primary" style={{ marginTop: '8px', justifyContent: 'center' }}>
                    {generating ? <RefreshCw size={15} className="animate-spin" /> : <Sparkles size={15} />}
                    {generating ? 'Drafting copy & rendering graphic...' : 'Generate Post & Creative'}
                  </button>
                </form>
              </div>

              {/* Preview Box */}
              <div className="glass-panel" style={{ padding: '24px' }}>
                <h3 style={{ fontSize: '15px', fontWeight: '700', marginBottom: '14px', color: '#f8fafc' }}>Generated Creative Preview</h3>

                {lastGenerated ? (
                  <div style={{ display: 'flex', flexDirection: 'column', gap: '14px' }}>
                    <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
                      <span className="badge badge-active">{lastGenerated.platform}</span>
                      <span className={`badge ${lastGenerated.qa_status === 'PASSED' ? 'badge-ready' : 'badge-draft'}`}>
                        QA Gate: {lastGenerated.qa_status}
                      </span>
                    </div>

                    <div style={{ fontSize: '13px', lineHeight: '1.5', background: 'rgba(10, 16, 30, 0.7)', padding: '14px', borderRadius: '10px', border: '1px solid rgba(40, 65, 110, 0.5)', maxHeight: '180px', overflowY: 'auto' }}>
                      <div style={{ whiteSpace: 'pre-line', color: '#e2e8f0' }}>{lastGenerated.caption}</div>
                      <div style={{ color: '#00f2fe', marginTop: '8px', fontSize: '12px' }}>{lastGenerated.hashtags}</div>
                    </div>

                    {lastGenerated.image_url && (
                      <div>
                        <div style={{ fontSize: '11px', color: '#94a3b8', marginBottom: '4px' }}>Rendered Asset (:5001):</div>
                        <img src={lastGenerated.image_url} alt="Brand creative" style={{ width: '100%', maxHeight: '250px', objectFit: 'contain', borderRadius: '8px', border: '1px solid rgba(0, 242, 254, 0.3)' }} />
                      </div>
                    )}
                  </div>
                ) : (
                  <div style={{ textAlign: 'center', padding: '50px 20px', color: '#94a3b8' }}>
                    <ImageIcon size={44} style={{ margin: '0 auto 12px auto', opacity: 0.4 }} />
                    <p style={{ fontSize: '13px' }}>Input a topic on the left to watch Vireonix AI formulate platform copy and render brand typography.</p>
                  </div>
                )}
              </div>
            </div>
          )}

          {/* TAB 3: CONTENT CALENDAR */}
          {activeTab === 'calendar' && (
            <div className="glass-panel" style={{ padding: '24px' }}>
              <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '18px' }}>
                <h2 style={{ fontSize: '18px', fontWeight: '800' }}>Master Content Calendar</h2>
                <div style={{ fontSize: '12px', color: '#94a3b8' }}>Shows all content in pipeline across statuses</div>
              </div>

              <div style={{ overflowX: 'auto' }}>
                <table style={{ width: '100%', borderCollapse: 'collapse', textAlign: 'left', fontSize: '13px' }}>
                  <thead>
                    <tr style={{ borderBottom: '1px solid rgba(40, 65, 110, 0.6)', color: '#94a3b8' }}>
                      <th style={{ padding: '10px 14px' }}>Content ID</th>
                      <th style={{ padding: '10px 14px' }}>Platform</th>
                      <th style={{ padding: '10px 14px' }}>Topic</th>
                      <th style={{ padding: '10px 14px' }}>Status</th>
                      <th style={{ padding: '10px 14px' }}>Approval</th>
                      <th style={{ padding: '10px 14px' }}>Actions</th>
                    </tr>
                  </thead>
                  <tbody>
                    {contentList.map(item => (
                      <tr key={item.id} style={{ borderBottom: '1px solid rgba(30, 48, 80, 0.4)' }}>
                        <td style={{ padding: '10px 14px', fontFamily: 'JetBrains Mono', color: '#00f2fe', fontSize: '11px' }}>{item.content_id}</td>
                        <td style={{ padding: '10px 14px' }}>
                          <span className="badge badge-active">{item.platform}</span>
                        </td>
                        <td style={{ padding: '10px 14px', fontWeight: '600', maxWidth: '300px' }}>{item.topic}</td>
                        <td style={{ padding: '10px 14px' }}>
                          <span className={`badge ${item.publishing_status === 'READY' ? 'badge-ready' : (item.publishing_status === 'PUBLISHED' ? 'badge-active' : 'badge-draft')}`}>
                            {item.publishing_status}
                          </span>
                        </td>
                        <td style={{ padding: '10px 14px' }}>{item.approval_status}</td>
                        <td style={{ padding: '10px 14px' }}>
                          <div style={{ display: 'flex', gap: '6px' }}>
                            {item.approval_status === 'DRAFT' && (
                              <button onClick={() => handleApprove(item.id, 'APPROVED')} className="btn-primary" style={{ padding: '4px 8px', fontSize: '11px' }}>
                                Approve
                              </button>
                            )}
                            {item.publishing_status !== 'PUBLISHED' && (
                              <button onClick={() => handlePublishNow(item.id)} className="btn-secondary" style={{ padding: '4px 8px', fontSize: '11px' }}>
                                Publish
                              </button>
                            )}
                            <button onClick={() => handleDeleteContent(item.id)} className="btn-danger" style={{ padding: '4px 8px' }}>
                              <Trash2 size={12} />
                            </button>
                          </div>
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            </div>
          )}

          {/* TAB 4: INSTAGRAM STUDIO */}
          {activeTab === 'instagram' && (
            <div className="glass-panel" style={{ padding: '24px' }}>
              <h2 style={{ fontSize: '18px', fontWeight: '800', marginBottom: '16px', display: 'flex', alignItems: 'center', gap: '8px' }}>
                <Instagram size={20} style={{ color: '#e1306c' }} /> Instagram Studio (1080x1350)
              </h2>
              <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(300px, 1fr))', gap: '16px' }}>
                {contentList.filter(c => c.platform.toLowerCase() === 'instagram').map(p => (
                  <div key={p.id} className="glass-card" style={{ padding: '16px', display: 'flex', flexDirection: 'column', gap: '10px' }}>
                    {p.image_url && (
                      <img src={p.image_url} alt="Creative" style={{ width: '100%', height: '220px', objectFit: 'cover', borderRadius: '8px' }} />
                    )}
                    <div style={{ fontSize: '14px', fontWeight: '700', color: '#f8fafc' }}>{p.topic}</div>
                    <div style={{ fontSize: '12px', color: '#94a3b8', maxHeight: '80px', overflowY: 'auto' }}>{p.caption}</div>
                    <div style={{ fontSize: '11px', color: '#00f2fe' }}>{p.hashtags}</div>
                    <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginTop: 'auto' }}>
                      <span className="badge badge-active">{p.publishing_status}</span>
                      <button onClick={() => handlePublishNow(p.id)} className="btn-primary" style={{ padding: '4px 10px', fontSize: '11px' }}>
                        Publish to IG
                      </button>
                    </div>
                  </div>
                ))}
              </div>
            </div>
          )}

          {/* TAB 5: LINKEDIN STUDIO */}
          {activeTab === 'linkedin' && (
            <div className="glass-panel" style={{ padding: '24px' }}>
              <h2 style={{ fontSize: '18px', fontWeight: '800', marginBottom: '16px', display: 'flex', alignItems: 'center', gap: '8px' }}>
                <Linkedin size={20} style={{ color: '#0a66c2' }} /> LinkedIn Studio (1080x1080)
              </h2>
              <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(320px, 1fr))', gap: '16px' }}>
                {contentList.filter(c => c.platform.toLowerCase() === 'linkedin').map(p => (
                  <div key={p.id} className="glass-card" style={{ padding: '16px', display: 'flex', flexDirection: 'column', gap: '10px' }}>
                    {p.image_url && (
                      <img src={p.image_url} alt="Creative" style={{ width: '100%', height: '180px', objectFit: 'contain', borderRadius: '8px' }} />
                    )}
                    <div style={{ fontSize: '14px', fontWeight: '700', color: '#f8fafc' }}>{p.topic}</div>
                    <div style={{ fontSize: '12px', color: '#cbd5e1', whiteSpace: 'pre-line', maxHeight: '100px', overflowY: 'auto' }}>{p.caption}</div>
                    <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginTop: 'auto' }}>
                      <span className="badge badge-ready">{p.publishing_status}</span>
                      <button onClick={() => handlePublishNow(p.id)} className="btn-primary" style={{ padding: '4px 10px', fontSize: '11px' }}>
                        Publish to LinkedIn
                      </button>
                    </div>
                  </div>
                ))}
              </div>
            </div>
          )}

          {/* TAB 6: WEBSITE & SEO */}
          {activeTab === 'seo' && (
            <div style={{ display: 'grid', gridTemplateColumns: '2fr 1fr', gap: '20px' }}>
              <div className="glass-panel" style={{ padding: '24px' }}>
                <h2 style={{ fontSize: '18px', fontWeight: '800', marginBottom: '16px' }}>Target SEO Keywords</h2>
                <div style={{ overflowX: 'auto' }}>
                  <table style={{ width: '100%', borderCollapse: 'collapse', textAlign: 'left', fontSize: '13px' }}>
                    <thead>
                      <tr style={{ borderBottom: '1px solid rgba(40, 65, 110, 0.6)', color: '#94a3b8' }}>
                        <th style={{ padding: '10px 12px' }}>Keyword</th>
                        <th style={{ padding: '10px 12px' }}>Intent</th>
                        <th style={{ padding: '10px 12px' }}>Volume</th>
                        <th style={{ padding: '10px 12px' }}>Priority</th>
                        <th style={{ padding: '10px 12px' }}>Actions</th>
                      </tr>
                    </thead>
                    <tbody>
                      {keywordsList.map(k => (
                        <tr key={k.id} style={{ borderBottom: '1px solid rgba(30, 48, 80, 0.4)' }}>
                          <td style={{ padding: '10px 12px', fontWeight: '700', color: '#f8fafc' }}>{k.keyword}</td>
                          <td style={{ padding: '10px 12px', color: '#cbd5e1' }}>{k.search_intent}</td>
                          <td style={{ padding: '10px 12px', fontFamily: 'JetBrains Mono', color: '#00f2fe' }}>{k.monthly_volume}/mo</td>
                          <td style={{ padding: '10px 12px' }}>
                            <span className={`badge ${k.priority === 'HIGH' ? 'badge-hot' : 'badge-draft'}`}>{k.priority}</span>
                          </td>
                          <td style={{ padding: '10px 12px' }}>
                            <button onClick={() => handleGenerateBlog(k.keyword)} disabled={blogGenerating} className="btn-primary" style={{ padding: '4px 8px', fontSize: '11px' }}>
                              Draft Blog
                            </button>
                          </td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
                </div>
              </div>

              {/* Add Keyword */}
              <div className="glass-panel" style={{ padding: '20px' }}>
                <h3 style={{ fontSize: '15px', fontWeight: '700', marginBottom: '12px' }}>Add Focus Keyword</h3>
                <form onSubmit={handleAddKeyword} style={{ display: 'flex', flexDirection: 'column', gap: '12px' }}>
                  <input
                    type="text"
                    placeholder="e.g. AI CRM software Madurai"
                    value={newKeyword}
                    onChange={e => setNewKeyword(e.target.value)}
                    style={{ padding: '10px 12px', background: 'rgba(18, 28, 50, 0.8)', border: '1px solid rgba(40, 65, 110, 0.6)', borderRadius: '8px', color: '#fff', fontSize: '13px' }}
                    required
                  />
                  <select
                    value={newIntent}
                    onChange={e => setNewIntent(e.target.value)}
                    style={{ padding: '10px 12px', background: 'rgba(18, 28, 50, 0.8)', border: '1px solid rgba(40, 65, 110, 0.6)', borderRadius: '8px', color: '#fff', fontSize: '13px' }}
                  >
                    <option value="Commercial">Commercial Intent</option>
                    <option value="Informational">Informational Intent</option>
                    <option value="Transactional">Transactional Intent</option>
                  </select>
                  <button type="submit" className="btn-primary" style={{ justifyContent: 'center' }}>
                    <Plus size={14} /> Add Keyword
                  </button>
                </form>
              </div>
            </div>
          )}

          {/* TAB 7: BLOG MANAGER */}
          {activeTab === 'blogs' && (
            <div style={{ display: 'grid', gridTemplateColumns: selectedBlog ? '1fr 1fr' : '1fr', gap: '20px' }}>
              <div className="glass-panel" style={{ padding: '24px' }}>
                <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '16px' }}>
                  <h2 style={{ fontSize: '18px', fontWeight: '800' }}>Technical Blog Articles ({blogsList.length})</h2>
                  <button onClick={() => handleGenerateBlog('AI automation for Indian SMEs')} disabled={blogGenerating} className="btn-primary" style={{ padding: '6px 12px', fontSize: '12px' }}>
                    <Sparkles size={13} /> {blogGenerating ? 'Generating...' : 'New AI Article'}
                  </button>
                </div>

                <div style={{ display: 'flex', flexDirection: 'column', gap: '12px' }}>
                  {blogsList.map(b => (
                    <div key={b.id} className="glass-card" style={{ padding: '14px', display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                      <div>
                        <div style={{ fontSize: '14px', fontWeight: '700', color: '#f8fafc' }}>{b.title}</div>
                        <div style={{ fontSize: '12px', color: '#00f2fe', fontFamily: 'JetBrains Mono' }}>{b.published_url}</div>
                        <div style={{ fontSize: '12px', color: '#94a3b8', marginTop: '4px' }}>{b.meta_description}</div>
                      </div>
                      <button onClick={() => setSelectedBlog(b)} className="btn-secondary" style={{ padding: '6px 10px', fontSize: '11px' }}>
                        <Eye size={13} /> View
                      </button>
                    </div>
                  ))}
                  {blogsList.length === 0 && <div style={{ color: '#94a3b8', textAlign: 'center', padding: '30px' }}>No blogs drafted yet. Click "New AI Article" to generate.</div>}
                </div>
              </div>

              {selectedBlog && (
                <div className="glass-panel" style={{ padding: '24px' }}>
                  <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '14px' }}>
                    <h3 style={{ fontSize: '16px', fontWeight: '700' }}>Article Markdown Preview</h3>
                    <button onClick={() => setSelectedBlog(null)} className="btn-secondary" style={{ padding: '4px 8px', fontSize: '11px' }}>Close</button>
                  </div>
                  <pre style={{ background: 'rgba(10, 16, 30, 0.8)', padding: '14px', borderRadius: '8px', color: '#cbd5e1', fontSize: '12px', whiteSpace: 'pre-wrap', maxHeight: '450px', overflowY: 'auto' }}>
                    {selectedBlog.markdown_content}
                  </pre>
                </div>
              )}
            </div>
          )}

          {/* TAB 8: LEADS & CRM */}
          {activeTab === 'leads' && (
            <div style={{ display: 'grid', gridTemplateColumns: '2fr 1fr', gap: '20px' }}>
              <div className="glass-panel" style={{ padding: '24px' }}>
                <h2 style={{ fontSize: '18px', fontWeight: '800', marginBottom: '16px' }}>Inbound CRM Leads Pipeline</h2>
                <div style={{ overflowX: 'auto' }}>
                  <table style={{ width: '100%', borderCollapse: 'collapse', textAlign: 'left', fontSize: '13px' }}>
                    <thead>
                      <tr style={{ borderBottom: '1px solid rgba(40, 65, 110, 0.6)', color: '#94a3b8' }}>
                        <th style={{ padding: '10px 12px' }}>Contact</th>
                        <th style={{ padding: '10px 12px' }}>Email / Phone</th>
                        <th style={{ padding: '10px 12px' }}>AI Score</th>
                        <th style={{ padding: '10px 12px' }}>Category</th>
                        <th style={{ padding: '10px 12px' }}>Status</th>
                      </tr>
                    </thead>
                    <tbody>
                      {leadsList.map(l => (
                        <tr key={l.id} style={{ borderBottom: '1px solid rgba(30, 48, 80, 0.4)' }}>
                          <td style={{ padding: '10px 12px' }}>
                            <div style={{ fontWeight: '700', color: '#f8fafc' }}>{l.full_name}</div>
                            <div style={{ fontSize: '11px', color: '#94a3b8' }}>{l.company}</div>
                          </td>
                          <td style={{ padding: '10px 12px', color: '#cbd5e1' }}>
                            <div>{l.email}</div>
                            <div style={{ fontSize: '11px', color: '#64748b' }}>{l.phone || 'N/A'}</div>
                          </td>
                          <td style={{ padding: '10px 12px', fontWeight: '800', color: l.lead_score >= 75 ? '#f87171' : '#34d399' }}>{l.lead_score}/100</td>
                          <td style={{ padding: '10px 12px' }}>
                            <span className={`badge ${l.category === 'HOT' ? 'badge-hot' : 'badge-draft'}`}>{l.category}</span>
                          </td>
                          <td style={{ padding: '10px 12px' }}>
                            <span className="badge badge-scheduled">{l.status}</span>
                          </td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
                </div>
              </div>

              {/* Lead Simulator */}
              <div className="glass-panel" style={{ padding: '20px' }}>
                <h3 style={{ fontSize: '15px', fontWeight: '700', marginBottom: '6px' }}>Simulate Inbound Inquiry</h3>
                <p style={{ fontSize: '11px', color: '#94a3b8', marginBottom: '14px' }}>Tests AI qualification scoring and follow-up recommendation.</p>

                <form onSubmit={handleLeadSubmit} style={{ display: 'flex', flexDirection: 'column', gap: '10px' }}>
                  <input
                    type="text"
                    placeholder="Prospect Name (e.g. Senthil Nathan)"
                    value={leadName}
                    onChange={e => setLeadName(e.target.value)}
                    style={{ padding: '8px 10px', background: 'rgba(18, 28, 50, 0.8)', border: '1px solid rgba(40, 65, 110, 0.6)', borderRadius: '6px', color: '#fff', fontSize: '13px' }}
                    required
                  />
                  <input
                    type="email"
                    placeholder="Business Email"
                    value={leadEmail}
                    onChange={e => setLeadEmail(e.target.value)}
                    style={{ padding: '8px 10px', background: 'rgba(18, 28, 50, 0.8)', border: '1px solid rgba(40, 65, 110, 0.6)', borderRadius: '6px', color: '#fff', fontSize: '13px' }}
                    required
                  />
                  <input
                    type="text"
                    placeholder="Company Name"
                    value={leadCompany}
                    onChange={e => setLeadCompany(e.target.value)}
                    style={{ padding: '8px 10px', background: 'rgba(18, 28, 50, 0.8)', border: '1px solid rgba(40, 65, 110, 0.6)', borderRadius: '6px', color: '#fff', fontSize: '13px' }}
                  />
                  <textarea
                    placeholder="Inquiry Details (e.g. Need automated inventory forecasting for our spinning mill)"
                    value={leadMessage}
                    onChange={e => setLeadMessage(e.target.value)}
                    style={{ padding: '8px 10px', background: 'rgba(18, 28, 50, 0.8)', border: '1px solid rgba(40, 65, 110, 0.6)', borderRadius: '6px', color: '#fff', fontSize: '13px', minHeight: '70px' }}
                  />

                  <button type="submit" disabled={leadSubmitting} className="btn-primary" style={{ justifyContent: 'center' }}>
                    {leadSubmitting ? 'Scoring with AI...' : 'Submit & Score'}
                  </button>
                </form>
              </div>
            </div>
          )}

          {/* TAB 9: COMPETITOR RADAR */}
          {activeTab === 'competitors' && (
            <div style={{ display: 'grid', gridTemplateColumns: '2fr 1fr', gap: '20px' }}>
              <div className="glass-panel" style={{ padding: '24px' }}>
                <h2 style={{ fontSize: '18px', fontWeight: '800', marginBottom: '16px' }}>Competitor Radar & Content Gaps</h2>
                <div style={{ display: 'flex', flexDirection: 'column', gap: '12px' }}>
                  {compData.competitors.map(c => (
                    <div key={c.id} className="glass-card" style={{ padding: '14px', display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                      <div>
                        <div style={{ fontSize: '14px', fontWeight: '700', color: '#f8fafc' }}>{c.name}</div>
                        <a href={c.website} target="_blank" rel="noreferrer" style={{ fontSize: '12px', color: '#00f2fe', textDecoration: 'none' }}>{c.website}</a>
                        <div style={{ fontSize: '12px', color: '#94a3b8', marginTop: '4px' }}>{c.notes}</div>
                      </div>
                    </div>
                  ))}
                </div>
              </div>

              <div className="glass-panel" style={{ padding: '20px' }}>
                <h3 style={{ fontSize: '15px', fontWeight: '700', marginBottom: '12px' }}>Track Competitor</h3>
                <form onSubmit={handleAddCompetitor} style={{ display: 'flex', flexDirection: 'column', gap: '10px' }}>
                  <input
                    type="text"
                    placeholder="Competitor Name"
                    value={compName}
                    onChange={e => setCompName(e.target.value)}
                    style={{ padding: '8px 10px', background: 'rgba(18, 28, 50, 0.8)', border: '1px solid rgba(40, 65, 110, 0.6)', borderRadius: '6px', color: '#fff', fontSize: '13px' }}
                    required
                  />
                  <input
                    type="url"
                    placeholder="Website (https://...)"
                    value={compSite}
                    onChange={e => setCompSite(e.target.value)}
                    style={{ padding: '8px 10px', background: 'rgba(18, 28, 50, 0.8)', border: '1px solid rgba(40, 65, 110, 0.6)', borderRadius: '6px', color: '#fff', fontSize: '13px' }}
                    required
                  />
                  <input
                    type="text"
                    placeholder="Positioning Notes"
                    value={compNotes}
                    onChange={e => setCompNotes(e.target.value)}
                    style={{ padding: '8px 10px', background: 'rgba(18, 28, 50, 0.8)', border: '1px solid rgba(40, 65, 110, 0.6)', borderRadius: '6px', color: '#fff', fontSize: '13px' }}
                  />
                  <button type="submit" className="btn-primary" style={{ justifyContent: 'center' }}>
                    <Plus size={14} /> Add Competitor
                  </button>
                </form>
              </div>
            </div>
          )}

          {/* TAB 10: EMAIL MARKETING */}
          {activeTab === 'email' && (
            <div className="glass-panel" style={{ padding: '24px' }}>
              <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '18px' }}>
                <div>
                  <h2 style={{ fontSize: '18px', fontWeight: '800' }}>Email Marketing & Newsletters</h2>
                  <div style={{ fontSize: '12px', color: '#94a3b8' }}>Total Opted-in Subscribers: <span style={{ color: '#34d399', fontWeight: '700' }}>{campaignData.subscribers}</span></div>
                </div>
                <button onClick={handleGenerateNewsletter} className="btn-primary" style={{ padding: '6px 12px', fontSize: '12px' }}>
                  <Mail size={14} /> Draft Weekly Newsletter
                </button>
              </div>

              <div style={{ display: 'flex', flexDirection: 'column', gap: '10px' }}>
                {campaignData.campaigns.map(c => (
                  <div key={c.id} className="glass-card" style={{ padding: '14px', display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                    <div>
                      <div style={{ fontSize: '14px', fontWeight: '700', color: '#f8fafc' }}>{c.name}</div>
                      <div style={{ fontSize: '12px', color: '#cbd5e1' }}>Subject: {c.subject_line}</div>
                    </div>
                    <span className="badge badge-scheduled">{c.status}</span>
                  </div>
                ))}
                {campaignData.campaigns.length === 0 && <div style={{ color: '#94a3b8', textAlign: 'center', padding: '30px' }}>No campaigns created yet. Click "Draft Weekly Newsletter" to compile with AI.</div>}
              </div>
            </div>
          )}

          {/* TAB 11: ANALYTICS & REPORTS */}
          {activeTab === 'analytics' && (
            <div className="glass-panel" style={{ padding: '24px' }}>
              <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '18px' }}>
                <h2 style={{ fontSize: '18px', fontWeight: '800' }}>Marketing Intelligence & Reports</h2>
                <button onClick={handleTriggerReport} className="btn-primary" style={{ padding: '6px 12px', fontSize: '12px' }}>
                  <TrendingUp size={14} /> Generate Weekly AI Review
                </button>
              </div>

              <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(220px, 1fr))', gap: '14px', marginBottom: '24px' }}>
                <div className="glass-card" style={{ padding: '16px' }}>
                  <div style={{ fontSize: '12px', color: '#94a3b8' }}>Posts Published</div>
                  <div style={{ fontSize: '24px', fontWeight: '800', color: '#34d399' }}>{stats?.posts?.published || 0}</div>
                </div>
                <div className="glass-card" style={{ padding: '16px' }}>
                  <div style={{ fontSize: '12px', color: '#94a3b8' }}>Scheduled in Queue</div>
                  <div style={{ fontSize: '24px', fontWeight: '800', color: '#60a5fa' }}>{stats?.posts?.scheduled || 0}</div>
                </div>
                <div className="glass-card" style={{ padding: '16px' }}>
                  <div style={{ fontSize: '12px', color: '#94a3b8' }}>Qualified Leads</div>
                  <div style={{ fontSize: '24px', fontWeight: '800', color: '#00f2fe' }}>{stats?.leads?.total_leads || 0}</div>
                </div>
              </div>
            </div>
          )}

          {/* TAB 12: PUBLISHING HISTORY */}
          {activeTab === 'history' && (
            <div className="glass-panel" style={{ padding: '24px' }}>
              <h2 style={{ fontSize: '18px', fontWeight: '800', marginBottom: '16px' }}>Publishing Execution Logs</h2>
              <div style={{ overflowX: 'auto' }}>
                <table style={{ width: '100%', borderCollapse: 'collapse', textAlign: 'left', fontSize: '13px' }}>
                  <thead>
                    <tr style={{ borderBottom: '1px solid rgba(40, 65, 110, 0.6)', color: '#94a3b8' }}>
                      <th style={{ padding: '10px 12px' }}>Time</th>
                      <th style={{ padding: '10px 12px' }}>Platform</th>
                      <th style={{ padding: '10px 12px' }}>Topic</th>
                      <th style={{ padding: '10px 12px' }}>Published Link</th>
                      <th style={{ padding: '10px 12px' }}>Status</th>
                    </tr>
                  </thead>
                  <tbody>
                    {pubLogs.map(log => (
                      <tr key={log.id} style={{ borderBottom: '1px solid rgba(30, 48, 80, 0.4)' }}>
                        <td style={{ padding: '10px 12px', color: '#94a3b8' }}>{log.published_at}</td>
                        <td style={{ padding: '10px 12px' }}>
                          <span className="badge badge-active">{log.platform}</span>
                        </td>
                        <td style={{ padding: '10px 12px', fontWeight: '600' }}>{log.topic || 'Scheduled Post'}</td>
                        <td style={{ padding: '10px 12px' }}>
                          <a href={log.post_url} target="_blank" rel="noreferrer" style={{ color: '#00f2fe', textDecoration: 'none', display: 'flex', alignItems: 'center', gap: '4px' }}>
                            View Post <ArrowUpRight size={12} />
                          </a>
                        </td>
                        <td style={{ padding: '10px 12px' }}>
                          <span className="badge badge-ready">{log.status}</span>
                        </td>
                      </tr>
                    ))}
                    {pubLogs.length === 0 && (
                      <tr>
                        <td colSpan={5} style={{ padding: '20px', textAlign: 'center', color: '#94a3b8' }}>No publishing logs recorded yet.</td>
                      </tr>
                    )}
                  </tbody>
                </table>
              </div>
            </div>
          )}

          {/* TAB 13: WORKFLOWS */}
          {activeTab === 'workflows' && (
            <div className="glass-panel" style={{ padding: '24px' }}>
              <h2 style={{ fontSize: '18px', fontWeight: '800', marginBottom: '8px' }}>Autonomous n8n Workflows</h2>
              <p style={{ fontSize: '12px', color: '#94a3b8', marginBottom: '20px' }}>
                10 production workflows orchestrating research, creation, rendering, publishing, SEO, CRM, and watchdog.
              </p>

              <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(280px, 1fr))', gap: '14px' }}>
                {workflowsList.map(wf => (
                  <div key={wf.id} className="glass-card" style={{ padding: '16px', display: 'flex', flexDirection: 'column', gap: '8px' }}>
                    <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                      <span style={{ fontSize: '11px', fontFamily: 'JetBrains Mono', color: '#00f2fe' }}>{wf.workflow_code}</span>
                      <span className="badge badge-ready">{wf.status}</span>
                    </div>
                    <div style={{ fontSize: '14px', fontWeight: '700', color: '#f8fafc' }}>{wf.name}</div>
                    <div style={{ fontSize: '11px', color: '#94a3b8' }}>Schedule: {wf.trigger_schedule}</div>
                  </div>
                ))}
              </div>
            </div>
          )}

          {/* TAB 14: SYSTEM DIAGNOSTICS & LOGS */}
          {activeTab === 'logs' && (
            <div style={{ display: 'flex', flexDirection: 'column', gap: '20px' }}>
              <div className="glass-panel" style={{ padding: '20px' }}>
                <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '16px' }}>
                  <div style={{ display: 'flex', alignItems: 'center', gap: '10px' }}>
                    <div style={{ background: 'linear-gradient(135deg, #4f46e5, #06b6d4)', padding: '8px', borderRadius: '8px' }}>
                      <Database size={18} color="#fff" />
                    </div>
                    <div>
                      <h2 style={{ fontSize: '17px', fontWeight: '800' }}>XAMPP MySQL Central Database Status</h2>
                      <div style={{ fontSize: '11px', color: '#94a3b8' }}>Connection Status, Engine Telemetry & Schema Integrity</div>
                    </div>
                  </div>
                  <span className={`badge ${dbStatus?.status === 'connected' ? 'badge-ready' : 'badge-hot'}`}>
                    {dbStatus?.status === 'connected' ? '● CONNECTED' : '● DISCONNECTED'}
                  </span>
                </div>

                <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(180px, 1fr))', gap: '12px' }}>
                  <div className="glass-card" style={{ padding: '12px' }}>
                    <div style={{ fontSize: '11px', color: '#94a3b8' }}>Database</div>
                    <div style={{ fontSize: '13px', fontWeight: '700', color: '#00f2fe' }}>{dbStatus?.database}</div>
                    <div style={{ fontSize: '10px', color: '#64748b' }}>utf8mb4_unicode_ci</div>
                  </div>
                  <div className="glass-card" style={{ padding: '12px' }}>
                    <div style={{ fontSize: '11px', color: '#94a3b8' }}>Host & Port</div>
                    <div style={{ fontSize: '13px', fontWeight: '700', color: '#f8fafc' }}>{dbStatus?.host}:{dbStatus?.port}</div>
                    <div style={{ fontSize: '10px', color: '#34d399' }}>Loopback (127.0.0.1)</div>
                  </div>
                  <div className="glass-card" style={{ padding: '12px' }}>
                    <div style={{ fontSize: '11px', color: '#94a3b8' }}>Version & Engine</div>
                    <div style={{ fontSize: '13px', fontWeight: '700', color: '#a78bfa' }}>{dbStatus?.server_version}</div>
                    <div style={{ fontSize: '10px', color: '#64748b' }}>{dbStatus?.engine}</div>
                  </div>
                  <div className="glass-card" style={{ padding: '12px' }}>
                    <div style={{ fontSize: '11px', color: '#94a3b8' }}>Active Tables</div>
                    <div style={{ fontSize: '13px', fontWeight: '700', color: '#38bdf8' }}>{dbStatus?.total_tables} Tables</div>
                    <div style={{ fontSize: '10px', color: '#34d399' }}>All Schemas Migrated</div>
                  </div>
                  <div className="glass-card" style={{ padding: '12px' }}>
                    <div style={{ fontSize: '11px', color: '#94a3b8' }}>Latest Error</div>
                    <div style={{ fontSize: '12px', fontWeight: '600', color: dbStatus?.latest_database_error ? '#f87171' : '#34d399' }}>
                      {dbStatus?.latest_database_error || 'None (Healthy)'}
                    </div>
                    <div style={{ fontSize: '10px', color: '#64748b' }}>Last Ping: {dbStatus?.last_successful_connection ? new Date(dbStatus.last_successful_connection).toLocaleTimeString() : 'N/A'}</div>
                  </div>
                </div>
              </div>

              <div className="glass-panel" style={{ padding: '24px' }}>
                <h2 style={{ fontSize: '18px', fontWeight: '800', marginBottom: '16px' }}>System Diagnostics & Event Logs</h2>
                <div style={{ overflowX: 'auto' }}>
                <table style={{ width: '100%', borderCollapse: 'collapse', textAlign: 'left', fontSize: '12px' }}>
                  <thead>
                    <tr style={{ borderBottom: '1px solid rgba(40, 65, 110, 0.6)', color: '#94a3b8' }}>
                      <th style={{ padding: '8px 12px' }}>Timestamp</th>
                      <th style={{ padding: '8px 12px' }}>Level</th>
                      <th style={{ padding: '8px 12px' }}>Source</th>
                      <th style={{ padding: '8px 12px' }}>Message</th>
                    </tr>
                  </thead>
                  <tbody>
                    {sysLogs.map(l => (
                      <tr key={l.id} style={{ borderBottom: '1px solid rgba(30, 48, 80, 0.3)' }}>
                        <td style={{ padding: '8px 12px', color: '#94a3b8' }}>{l.created_at}</td>
                        <td style={{ padding: '8px 12px' }}>
                          <span className={`badge ${l.level === 'INFO' ? 'badge-active' : 'badge-hot'}`}>{l.level}</span>
                        </td>
                        <td style={{ padding: '8px 12px', color: '#00f2fe', fontFamily: 'JetBrains Mono' }}>{l.source}</td>
                        <td style={{ padding: '8px 12px', color: '#e2e8f0' }}>{l.message}</td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            </div>
          </div>
        )}

          {/* TAB 15: SETTINGS */}
          {activeTab === 'settings' && (
            <div className="glass-panel" style={{ padding: '24px', maxWidth: '750px' }}>
              <h2 style={{ fontSize: '18px', fontWeight: '800', marginBottom: '18px' }}>Global Configuration & Operating Rules</h2>
              <div style={{ display: 'flex', flexDirection: 'column', gap: '12px' }}>
                {Object.entries(settings).map(([k, v]) => (
                  <div key={k} className="glass-card" style={{ padding: '12px 16px', display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                    <div>
                      <div style={{ fontSize: '13px', fontWeight: '700', color: '#f8fafc' }}>{k}</div>
                      <div style={{ fontSize: '12px', color: '#94a3b8', maxWidth: '450px', wordBreak: 'break-all' }}>{v}</div>
                    </div>
                  </div>
                ))}
              </div>
            </div>
          )}
        </div>
      </main>
    </div>
  );
}
