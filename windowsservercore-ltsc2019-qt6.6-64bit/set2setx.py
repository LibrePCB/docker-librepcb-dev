import os
import sys
import subprocess

for line in sys.stdin:
    line = line.rstrip()
    key, value = line.split('=', maxsplit=1)
    cmd = 'cmd.exe /C "setx ' + key + ' "' + value + '""'
    if key == 'PATH':
        paths = []
        [paths.append(p) for p in value.split(';') if os.path.isdir(p) and p not in paths]
        value = ';'.join(paths)
    print(cmd)
    subprocess.check_output(cmd)
