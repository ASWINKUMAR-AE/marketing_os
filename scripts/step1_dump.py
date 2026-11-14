import subprocess
import os
import sys

print("==================================================")
print("  Step 1: Backup & Dump zethub_marketing_os       ")
print("==================================================")

dump_tool = r"D:\xampp\mysql\bin\mysqldump.exe"
out_file = r"D:\marketing_os\database\zethub_marketing_os_migration.sql"

if not os.path.exists(dump_tool):
    print(f"Dump tool not found at {dump_tool}")
    sys.exit(1)

cmd = f'"{dump_tool}" -u root -P 3306 -h 127.0.0.1 --routines --triggers --databases zethub_marketing_os'
print(f"Executing: {cmd}")

with open(out_file, "w", encoding="utf-8") as f:
    proc = subprocess.run(cmd, stdout=f, stderr=subprocess.PIPE, text=True, shell=True)
    if proc.returncode == 0:
        size = os.path.getsize(out_file)
        print(f"SUCCESS: Dump completed! File: {out_file} ({size:,} bytes)")
    else:
        print(f"ERROR during mysqldump: {proc.stderr}")
        sys.exit(1)

# Verify dump file content
with open(out_file, "r", encoding="utf-8", errors="ignore") as f:
    content = f.read()
    tables = [line for line in content.splitlines() if "CREATE TABLE" in line]
    print(f"Verified {len(tables)} tables present in SQL dump.")

