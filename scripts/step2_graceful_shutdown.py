import subprocess
import time
import socket
import sys

print("==================================================")
print("  Step 2: Graceful Shutdown of D:\\xampp MySQL     ")
print("==================================================")

admin_tool = r"D:\xampp\mysql\bin\mysqladmin.exe"
cmd = f'"{admin_tool}" -u root -h 127.0.0.1 -P 3306 shutdown'

print(f"Executing graceful shutdown: {cmd}")
proc = subprocess.run(cmd, shell=True, text=True, capture_output=True)
print(f"mysqladmin output: {proc.stdout.strip()} {proc.stderr.strip()}")

# Wait and check if port 3306 is released
print("Waiting for port 3306 to be released...")
released = False
for i in range(15):
    time.sleep(1)
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sock.settimeout(1)
    result = sock.connect_ex(('127.0.0.1', 3306))
    sock.close()
    if result != 0:
        print(f"Port 3306 is now FREE! (verified after {i+1}s)")
        released = True
        break

if not released:
    print("WARNING: Port 3306 is still occupied.")
    sys.exit(1)
else:
    print("SUCCESS: Old D:\\xampp MySQL cleanly stopped without force kill.")

