import pymysql

print("--- Updating Brand Settings & LinkedIn Info in XAMPP MySQL ---")
conn = pymysql.connect(host='127.0.0.1', port=3306, user='root', password='', database='zethub_marketing_os')
with conn.cursor() as cur:
    settings = [
        ('COMPANY_NAME', 'ZETHUB TECHNOLOGIES PRIVATE LIMITED', 'Brand company name'),
        ('COMPANY_TAGLINE', 'Where Innovations meets our Excellence', 'Company tagline'),
        ('LINKEDIN_URL', 'https://www.linkedin.com/company/zethub-technologies-private-limited', 'LinkedIn company URL'),
        ('LINKEDIN_HANDLE', 'zethub-technologies-private-limited', 'LinkedIn company handle'),
        ('LINKEDIN_COMPANY_ID', 'zethub-technologies-private-limited', 'LinkedIn company page ID')
    ]
    for k, v, desc in settings:
        cur.execute(
            'INSERT INTO settings (setting_key, setting_value, description) VALUES (%s, %s, %s) '
            'ON DUPLICATE KEY UPDATE setting_value = VALUES(setting_value), description = VALUES(description)',
            (k, v, desc)
        )
    print("Settings table updated.")

    # Update social_accounts for LinkedIn
    cur.execute('DELETE FROM social_accounts WHERE platform_id = 2')
    cur.execute(
        'INSERT INTO social_accounts (platform_id, account_name, account_id, is_connected) '
        'VALUES (2, %s, %s, 1)',
        ('ZETHUB TECHNOLOGIES PRIVATE LIMITED', 'zethub-technologies-private-limited')
    )
    print("social_accounts table updated for LinkedIn.")

    conn.commit()

    cur.execute("SELECT setting_key, setting_value FROM settings WHERE setting_key IN ('COMPANY_NAME', 'COMPANY_TAGLINE', 'LINKEDIN_URL', 'LINKEDIN_HANDLE')")
    for r in cur.fetchall():
        print(f"  • {r[0]}: {r[1]}")
conn.close()
print("Done!")

