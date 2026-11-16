#!/usr/bin/env python3
"""Check selected original SMV models, then build the Lean proofs."""
import argparse
import os
from pathlib import Path
import shutil
import subprocess

root = Path(__file__).resolve().parents[1]
os.chdir(root)
parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('--system', choices=['counter', 'gcd', 'mutex', 'all'], default='counter')
args = parser.parse_args()
checker = os.environ.get('SMV_CHECKER') or shutil.which('NuSMV') or shutil.which('nuXmv')
if not checker:
    local = root / '.tools/nuXmv-2.2.0-macos64/usr/local/bin/nuXmv'
    if local.exists():
        checker = str(local)
if not checker:
    raise SystemExit('Install NuSMV or nuXmv and set SMV_CHECKER to its path; see README.')

properties = {
    'counter': 'x <= count_max',
    'gcd': 'pc = l5 -> a = b',
    'mutex': '!(process1 = critical & process2 = critical)',
}
selected = properties if args.system == 'all' else {args.system: properties[args.system]}
for system, prop in selected.items():
    commands = (f'read_model -i models/leansmv/{system}.smv\n'
                f'go\ncheck_invar -p "{prop}"\nquit\n')
    print(f'\n{system}: full finite invariant check\n$ {checker} -int\n{commands}', flush=True)
    result = subprocess.run([checker, '-int'], input=commands, text=True,
                            stdout=subprocess.PIPE, stderr=subprocess.STDOUT, check=True)
    print(result.stdout, end='', flush=True)
    verdicts = [line for line in result.stdout.splitlines() if '-- invariant ' in line]
    if len(verdicts) != 1 or not verdicts[0].rstrip().endswith(' is true'):
        raise SystemExit(f'The verifier did not report the {system} invariant as true.')

print('$ lake build', flush=True)
subprocess.run(['lake', 'build'], check=True)
print(f'Passed: finite checks for {", ".join(selected)} and all project Lean proofs. No BMC was run.')
