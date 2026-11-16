#!/usr/bin/env python3
"""Check the original counter with NuSMV/nuXmv, then build the Lean proofs."""
import os
from pathlib import Path
import shutil
import subprocess

root = Path(__file__).resolve().parents[1]
os.chdir(root)
checker = os.environ.get('SMV_CHECKER') or shutil.which('NuSMV') or shutil.which('nuXmv')
if not checker:
    local = root / '.tools/nuXmv-2.2.0-macos64/usr/local/bin/nuXmv'
    if local.exists():
        checker = str(local)
if not checker:
    raise SystemExit('Install NuSMV or nuXmv and set SMV_CHECKER to its path; see README.')

commands = '''read_model -i models/leansmv/counter.smv
go
check_invar -p "x <= count_max"
quit
'''
print(f'$ {checker} -int\n{commands}', flush=True)
result = subprocess.run([checker, '-int'], input=commands, text=True,
                        stdout=subprocess.PIPE, stderr=subprocess.STDOUT, check=True)
print(result.stdout, end='', flush=True)
if 'x <= count_max  is true' not in result.stdout:
    raise SystemExit('The verifier did not report the counter invariant as true.')

print('$ lake build', flush=True)
subprocess.run(['lake', 'build'], check=True)
print('Passed: full finite check at N=10 and arbitrary-N Lean proof. No BMC was run.')
