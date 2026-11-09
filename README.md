# File Integrity Monitoring Lab

A small Bash-based file integrity monitor (FIM) that detects modified, deleted and unexpected files by comparing them against a trusted SHA-256 baseline.

## Why this matters
File integrity monitoring is a core security control. Attackers who gain access often modify configuration files, remove logs or drop backdoors. A FIM detects those changes by noticing when a file's cryptographic hash no longer matches a known-good value.

## How it works
1. `baseline.sha256` stores the SHA-256 hash of each file in `data/` in its clean state.
2. `scripts/check.sh` runs two checks:
   - **Hash check**: `sha256sum -c` flags modified or missing files.
   - **File list check**: `diff` compares the baseline's file list with the files actually on disk, catching new files the hash check can't see.

## Lab environment
- Kali Linux VM (VirtualBox)
- Bash, `sha256sum`, `diff`, `awk`

## Usage
```bash
git clone git@github.com:Emmmixcodes/file-integrity-monitoring-lab.git
cd file-integrity-monitoring-lab
./scripts/check.sh
```
No output under the headings means no changes were detected.

## Demo: simulated tampering
I simulated three attacker actions:
```bash
echo "Allow all inbound traffic." > data/firewall.txt   # modify
echo "reverse shell placeholder" > data/backdoor.txt    # add
rm data/backup.txt                                      # delete
```
The monitor detected all three (full output in [`docs/detection-output.txt`](docs/detection-output.txt)):

| Action | Detected by | Result |
|---|---|---|
| Modified `firewall.txt` | Hash check | `FAILED` |
| Deleted `backup.txt` | Hash check + file list | `FAILED open or read`, shown as removed |
| Added `backdoor.txt` | File list check | shown as new |

## Limitations
- The baseline sits next to the monitored files, so an attacker with write access could rewrite both. A real deployment stores the baseline separately or read-only.
- The check is manual and not real-time.

## Next steps
Real-time FIM with Wazuh is covered in my Wazuh detection lab (in progress).

## What I learned
- How cryptographic hashes detect tampering
- Why integrity checks need both content and file-list comparison
- Writing portable Bash scripts and documenting evidence for reproducibility
