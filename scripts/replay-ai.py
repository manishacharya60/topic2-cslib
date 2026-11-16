#!/usr/bin/env python3
"""Check the saved AI proof in Lean. Does not call a model or edit the proof."""
import argparse
from pathlib import Path
import subprocess
import tempfile

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('--attempt', type=int, choices=[1, 2], default=2)
args = parser.parse_args()
root = Path(__file__).resolve().parents[1]
trial = root / 'experiments/counter/ai'
context = (trial / 'Frozen.lean.in').read_text()
proof = (trial / f'attempt{args.attempt}.proof.txt').read_text()

with tempfile.TemporaryDirectory(prefix='counter-ai-') as folder:
    candidate = Path(folder) / 'Candidate.lean'
    candidate.write_text(context.replace('__PROOF__', proof))
    result = subprocess.run(['lake', 'env', 'lean', '-DwarningAsError=true', str(candidate)],
                            cwd=root)
print(f'Attempt {args.attempt}: Lean exit code {result.returncode}')
raise SystemExit(result.returncode)
