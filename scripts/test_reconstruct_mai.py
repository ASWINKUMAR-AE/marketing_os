import shutil
import subprocess
import os

print("--- Testing Index reconstruction using template MAI ---")
mysql_dir = r"D:\xampp_new\mysql\data\mysql"
backup_mysql = r"D:\xampp_new\mysql\backup\mysql"

# Copy clean MAI template to data\mysql
shutil.copy2(os.path.join(backup_mysql, "global_priv.MAI"), os.path.join(mysql_dir, "global_priv.MAI"))

# Now try aria_chk -r
aria_chk = r"D:\xampp_new\mysql\bin\aria_chk.exe"
cmd = f'"{aria_chk}" -r -s mysql/global_priv.MAI'
proc = subprocess.run(cmd, cwd=r"D:\xampp_new\mysql\data", shell=True, text=True, capture_output=True)
print("aria_chk STDOUT:", proc.stdout.strip())
print("aria_chk STDERR:", proc.stderr.strip())
print("Return code:", proc.returncode)

