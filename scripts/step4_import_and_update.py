import pymysql
import subprocess
import os
import sys

print("==================================================")
print("  Step 4: Import zethub_marketing_os to D:\\xampp_new")
print("==================================================")

# 1. Create DB if not exists
conn = pymysql.connect(host="127.0.0.1", port=3306, user="root", password="")
with conn.cursor() as cur:
    cur.execute("CREATE DATABASE IF NOT EXISTS zethub_marketing_os CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;")
    print("Database zethub_marketing_os ensured with utf8mb4.")
conn.close()

# 2. Import dump using mysql.exe from D:\xampp_new\mysql\bin
mysql_tool = r"D:\xampp_new\mysql\bin\mysql.exe"
dump_file = r"D:\marketing_os\database\zethub_marketing_os_migration.sql"

cmd = f'"{mysql_tool}" -u root -h 127.0.0.1 -P 3306 zethub_marketing_os'
print(f"Importing {dump_file} into D:\\xampp_new MySQL...")

with open(dump_file, "r", encoding="utf-8") as f:
    proc = subprocess.run(cmd, stdin=f, shell=True, text=True, capture_output=True)
    if proc.returncode == 0:
        print("Import completed successfully!")
    else:
        print(f"Import output / warnings: {proc.stderr}")

# 3. Verify tables and update brand settings
conn = pymysql.connect(host="127.0.0.1", port=3306, user="root", password="", database="zethub_marketing_os")
with conn.cursor() as cur:
    cur.execute("SHOW TABLES")
    tables = [r[0] for r in cur.fetchall()]
    print(f"\nTotal tables in D:\\xampp_new zethub_marketing_os: {len(tables)}")
    
    # Update brand settings with User's specific info
    updates = [
        ("company_name", "ZETHUB TECHNOLOGIES PRIVATE LIMITED"),
        ("linkedin_url", "https://www.linkedin.com/company/zethub-technologies-private-limited"),
        ("linkedin_handle", "zethub-technologies-private-limited"),
        ("tagline", "Where Innovations meets our Excellence")
    ]
    for k, v in updates:
        cur.execute(
            "INSERT INTO brand_settings (setting_key, setting_value) VALUES (%s, %s) "
            "ON DUPLICATE KEY UPDATE setting_value = VALUES(setting_value)",
            (k, v)
        )
    print("Updated brand_settings with exact LinkedIn details.")
    
    # Update platforms table
    cur.execute(
        "UPDATE platforms SET account_handle = %s, account_name = %s WHERE platform_name = 'linkedin'",
        ('zethub-technologies-private-limited', 'ZETHUB TECHNOLOGIES PRIVATE LIMITED')
    )
    print("Updated platforms table for LinkedIn.")
    
    conn.commit()
    
    # Verify brand settings
    cur.execute("SELECT setting_key, setting_value FROM brand_settings WHERE setting_key IN ('company_name', 'linkedin_url', 'tagline')")
    for r in cur.fetchall():
        print(f"  • {r[0]}: {r[1]}")

conn.close()
print("\nStep 4 Finished Successfully!")

