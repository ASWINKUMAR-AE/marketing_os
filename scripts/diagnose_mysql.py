import subprocess
import socket
import os
import pymysql

print("==================================================")
print("       XAMPP MySQL Diagnostic Inspection         ")
print("==================================================")

# 1. Inspect Port 3306 binding via netstat
print("\n[1] Port 3306 Ownership Check:")
try:
    netstat_out = subprocess.check_output("netstat -ano", shell=True, text=True)
    listening_pids = []
    for line in netstat_out.splitlines():
        if ":3306" in line and "LISTENING" in line.upper():
            parts = line.strip().split()
            pid = parts[-1]
            listening_pids.append(pid)
            print(f"  • Found 3306 listener line: {line.strip()}")
            print(f"    --> Listening PID: {pid}")
            
            # Find process name for this PID
            try:
                tasklist_out = subprocess.check_output(f'tasklist /fi "PID eq {pid}"', shell=True, text=True)
                print(f"    --> Process info:\n{tasklist_out.strip()}")
            except Exception as e:
                print(f"    --> Could not query tasklist: {e}")
                
    if not listening_pids:
        print("  Port 3306 is NOT currently listening.")
except Exception as e:
    print(f"  Netstat check failed: {e}")

# 2. Check XAMPP paths
print("\n[2] XAMPP Directory Structure:")
xampp_paths = [r"D:\xampp", r"D:\xampp_new"]
for xp in xampp_paths:
    exists = os.path.exists(xp)
    print(f"\n  • Directory: {xp} [{'FOUND' if exists else 'NOT FOUND'}]")
    if exists:
        mysql_bin = os.path.join(xp, "mysql", "bin", "mysqld.exe")
        my_ini = os.path.join(xp, "mysql", "bin", "my.ini")
        data_dir = os.path.join(xp, "mysql", "data")
        control_exe = os.path.join(xp, "xampp-control.exe")
        
        print(f"    - xampp-control.exe : {'EXISTS' if os.path.exists(control_exe) else 'MISSING'}")
        print(f"    - mysqld.exe        : {'EXISTS' if os.path.exists(mysql_bin) else 'MISSING'}")
        print(f"    - my.ini            : {'EXISTS' if os.path.exists(my_ini) else 'MISSING'}")
        print(f"    - data dir          : {'EXISTS' if os.path.exists(data_dir) else 'MISSING'}")
        
        if os.path.exists(my_ini):
            with open(my_ini, 'r', encoding='latin1', errors='ignore') as f:
                content = f.read()
                # find datadir and port
                for l in content.splitlines():
                    if l.strip().startswith("port") or l.strip().startswith("datadir"):
                        print(f"      config: {l.strip()}")
                        
        if os.path.exists(data_dir):
            db_dir = os.path.join(data_dir, "zethub_marketing_os")
            print(f"    - zethub_marketing_os DB: {'EXISTS' if os.path.exists(db_dir) else 'NOT FOUND'}")

# 3. Check MySQL Connection & Health via PyMySQL
print("\n[3] MySQL Server & Database Probe (127.0.0.1:3306):")
try:
    conn = pymysql.connect(
        host="127.0.0.1",
        port=3306,
        user="root",
        password="",
        connect_timeout=3
    )
    with conn.cursor() as cursor:
        cursor.execute("SELECT VERSION()")
        ver = cursor.fetchone()[0]
        cursor.execute("SELECT @@datadir, @@port, @@basedir")
        datadir, port, basedir = cursor.fetchone()
        cursor.execute("SHOW DATABASES LIKE 'zethub_marketing_os'")
        db_exists = cursor.fetchone() is not None
        
        print(f"  • Connection: SUCCESS")
        print(f"  • Server Version: {ver}")
        print(f"  • Basedir: {basedir}")
        print(f"  • Datadir: {datadir}")
        print(f"  • Port: {port}")
        print(f"  • Database 'zethub_marketing_os' exists: {db_exists}")
        
        if db_exists:
            cursor.execute("USE zethub_marketing_os")
            cursor.execute("SHOW TABLES")
            tables = [r[0] for r in cursor.fetchall()]
            print(f"  • Total Tables in zethub_marketing_os: {len(tables)}")
            
            # Check brand_settings table
            if 'brand_settings' in tables:
                cursor.execute("SELECT setting_key, setting_value FROM brand_settings LIMIT 10")
                rows = cursor.fetchall()
                print("  • Brand Settings Sample:")
                for k, v in rows:
                    print(f"      {k}: {v}")
    conn.close()
except Exception as e:
    print(f"  • MySQL Connection FAILED: {e}")
