import subprocess
import time
import socket
import os
import sys
import pymysql

print("==================================================")
print("  Step 3: Launch D:\\xampp_new MySQL (MariaDB 10.4) ")
print("==================================================")

xampp_new_bin = r"D:\xampp_new\mysql\bin\mysqld.exe"
my_ini = r"D:\xampp_new\mysql\bin\my.ini"

if not os.path.exists(xampp_new_bin):
    print(f"Error: {xampp_new_bin} not found!")
    sys.exit(1)

# Check if port 3306 is already listening
sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
sock.settimeout(1)
res = sock.connect_ex(('127.0.0.1', 3306))
sock.close()

if res != 0:
    print(f"Starting {xampp_new_bin}...")
    # Launch detached process using CREATE_NEW_PROCESS_GROUP and DETACHED_PROCESS
    DETACHED_PROCESS = 0x00000008
    CREATE_NEW_PROCESS_GROUP = 0x00000200
    subprocess.Popen(
        [xampp_new_bin, f"--defaults-file={my_ini}", "--standalone"],
        cwd=r"D:\xampp_new",
        creationflags=DETACHED_PROCESS | CREATE_NEW_PROCESS_GROUP,
        close_fds=True
    )
    print("Process spawned. Waiting for port 3306 to listen...")
    time.sleep(3)
else:
    print("Port 3306 is already active.")

# Verify connection and version
for attempt in range(10):
    try:
        conn = pymysql.connect(
            host="127.0.0.1",
            port=3306,
            user="root",
            password="",
            connect_timeout=2
        )
        with conn.cursor() as cursor:
            cursor.execute("SELECT VERSION()")
            ver = cursor.fetchone()[0]
            cursor.execute("SELECT @@datadir, @@port")
            datadir, port = cursor.fetchone()
            print("\nSUCCESS! Connected to active MySQL instance:")
            print(f"  • Server Version: {ver}")
            print(f"  • Data Directory: {datadir}")
            print(f"  • Port: {port}")
        conn.close()
        break
    except Exception as e:
        print(f"  Waiting for MySQL... ({attempt+1}/10) ({e})")
        time.sleep(1)

