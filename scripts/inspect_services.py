import subprocess
import os

print("--- Checking XAMPP Control Panel & Services ---")

# Check running xampp-control
try:
    tasklist_out = subprocess.check_output('tasklist /v | findstr /i "xampp mysqld"', shell=True, text=True)
    print("Running Processes:")
    print(tasklist_out)
except Exception as e:
    print(f"Tasklist check: {e}")

# Check Windows services
try:
    sc_out = subprocess.check_output('sc query type= service state= all | findstr /i "mysql mariadb xampp"', shell=True, text=True)
    print("Related Windows Services:")
    print(sc_out if sc_out.strip() else "No MySQL/MariaDB/XAMPP Windows services found.")
except Exception as e:
    print(f"SC query: {e}")

# Check mysqld versions
for xp in [r"D:\xampp", r"D:\xampp_new"]:
    exe = os.path.join(xp, "mysql", "bin", "mysqld.exe")
    if os.path.exists(exe):
        try:
            ver_out = subprocess.check_output(f'"{exe}" --version', shell=True, text=True)
            print(f"{xp} mysqld version: {ver_out.strip()}")
        except Exception as e:
            print(f"{xp} version check failed: {e}")

