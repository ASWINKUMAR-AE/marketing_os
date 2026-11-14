"""
ZetHub Marketing OS - Enterprise MySQL Backup & Recovery Manager
Utilizes XAMPP's native mysqldump and mysql tools.
Features: Timestamped dumps, integrity verification, automated retention, and restore support.
"""

import os
import sys
import glob
import subprocess
import datetime
import argparse
import pymysql

BACKUP_DIR = r"D:\marketing_os\database\backups"
DEFAULT_RETENTION = 30  # Keep last 30 backups

# Locate mysqldump
def get_dump_tool():
    for base in [r"D:\xampp_new", r"D:\xampp"]:
        tool = os.path.join(base, "mysql", "bin", "mysqldump.exe")
        if os.path.exists(tool):
            return tool
    raise FileNotFoundError("mysqldump.exe not found in D:\\xampp_new or D:\\xampp")

# Locate mysql CLI
def get_mysql_tool():
    for base in [r"D:\xampp_new", r"D:\xampp"]:
        tool = os.path.join(base, "mysql", "bin", "mysql.exe")
        if os.path.exists(tool):
            return tool
    raise FileNotFoundError("mysql.exe not found in D:\\xampp_new or D:\\xampp")


def log_event(level: str, message: str):
    """Safely logs backup events to MySQL system_logs table."""
    try:
        conn = pymysql.connect(host="127.0.0.1", port=3306, user="root", password="", database="zethub_marketing_os")
        with conn.cursor() as cur:
            cur.execute(
                "INSERT INTO system_logs (level, source, message) VALUES (%s, %s, %s)",
                (level, "BackupManager", message)
            )
            conn.commit()
        conn.close()
    except Exception:
        pass


def create_backup(retention: int = DEFAULT_RETENTION) -> str:
    """Creates a validated, timestamped SQL backup of zethub_marketing_os."""
    os.makedirs(BACKUP_DIR, exist_ok=True)
    timestamp = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
    out_file = os.path.join(BACKUP_DIR, f"zethub_marketing_os_{timestamp}.sql")
    dump_tool = get_dump_tool()

    cmd = f'"{dump_tool}" -u root -h 127.0.0.1 -P 3306 --routines --triggers --databases zethub_marketing_os'
    print(f"[*] Starting MySQL Backup using {dump_tool}...")
    print(f"[*] Target file: {out_file}")

    with open(out_file, "w", encoding="utf-8") as f:
        proc = subprocess.run(cmd, stdout=f, stderr=subprocess.PIPE, text=True, shell=True)

    if proc.returncode != 0:
        err = f"mysqldump failed: {proc.stderr}"
        print(f"[!] {err}")
        log_event("ERROR", err)
        if os.path.exists(out_file):
            os.remove(out_file)
        sys.exit(1)

    # Validate backup integrity
    file_size = os.path.getsize(out_file)
    if file_size < 10000:
        err = f"Backup failed validation: file size {file_size} bytes is too small."
        print(f"[!] {err}")
        log_event("ERROR", err)
        sys.exit(1)

    # Verify table count in dump
    table_count = 0
    with open(out_file, "r", encoding="utf-8", errors="ignore") as f:
        for line in f:
            if "CREATE TABLE" in line:
                table_count += 1

    if table_count < 20:
        err = f"Backup failed validation: only found {table_count} tables in dump."
        print(f"[!] {err}")
        log_event("ERROR", err)
        sys.exit(1)

    msg = f"Backup validated successfully: {out_file} ({file_size:,} bytes, {table_count} tables)."
    print(f"[OK] {msg}")
    log_event("INFO", msg)

    # Apply Retention Policy
    prune_old_backups(retention)
    return out_file


def prune_old_backups(retention: int):
    """Keeps the most recent `retention` backups and safely deletes older ones."""
    pattern = os.path.join(BACKUP_DIR, "zethub_marketing_os_*.sql")
    files = sorted(glob.glob(pattern), key=os.path.getmtime, reverse=True)
    if len(files) > retention:
        to_delete = files[retention:]
        for old in to_delete:
            try:
                os.remove(old)
                print(f"[*] Pruned old backup: {os.path.basename(old)}")
            except Exception as e:
                print(f"[!] Failed to prune {old}: {e}")


def restore_backup(sql_file: str):
    """Restores zethub_marketing_os from a specified SQL backup file."""
    if not os.path.exists(sql_file):
        print(f"[!] Backup file not found: {sql_file}")
        sys.exit(1)

    mysql_tool = get_mysql_tool()
    print(f"[*] Restoring database from {sql_file} using {mysql_tool}...")

    cmd = f'"{mysql_tool}" -u root -h 127.0.0.1 -P 3306 zethub_marketing_os'
    with open(sql_file, "r", encoding="utf-8") as f:
        proc = subprocess.run(cmd, stdin=f, shell=True, text=True, capture_output=True)

    if proc.returncode != 0:
        print(f"[!] Restore failed: {proc.stderr}")
        log_event("ERROR", f"Restore failed from {sql_file}: {proc.stderr}")
        sys.exit(1)

    print(f"[OK] Database restored successfully from {sql_file}!")
    log_event("INFO", f"Database successfully restored from {sql_file}")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="ZetHub XAMPP MySQL Backup & Recovery Tool")
    parser.add_argument("--backup", action="store_true", help="Create a verified timestamped backup")
    parser.add_argument("--restore", type=str, help="Restore database from a specific SQL dump file")
    parser.add_argument("--retention", type=int, default=DEFAULT_RETENTION, help="Number of backups to retain")
    args = parser.parse_args()

    if args.restore:
        restore_backup(args.restore)
    else:
        create_backup(args.retention)

