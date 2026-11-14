import subprocess
import os

print("--- Running aria_chk from data directory ---")
aria_chk = r"D:\xampp_new\mysql\bin\aria_chk.exe"
cmd = f'"{aria_chk}" -c -r -s mysql/global_priv.MAI'

proc = subprocess.run(cmd, cwd=r"D:\xampp_new\mysql\data", shell=True, text=True, capture_output=True)
print("aria_chk STDOUT:\n", proc.stdout)
print("aria_chk STDERR:\n", proc.stderr)
print(f"Return code: {proc.returncode}")
