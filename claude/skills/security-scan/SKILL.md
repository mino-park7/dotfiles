---
name: security-scan
description: "Scan code for security vulnerabilities and provide fix guidance. Use when the user asks to find security issues, vulnerabilities, security review, hardcoded secrets, injection flaws, or anything related to code security auditing. Covers Python and C++ codebases including NPU SDK and ML framework contexts."
---

# Security Vulnerability Scanner

Scan Python and C++ codebases for security vulnerabilities and provide actionable fix guidance. Tailored for NPU SDK, vLLM, and eDSL (legato) development environments.

## Agent Behavior

- **Run scans autonomously** — do not ask for confirmation before read-only analysis.
- **Show all findings** grouped by severity (CRITICAL → HIGH → MEDIUM → LOW).
- **Provide a concrete fix** for every finding — not just "this is bad", but the corrected code.
- **Only modify files when explicitly asked** to apply fixes.

---

## Step 1: Detect Environment

```bash
# Check available scanners
which bandit 2>/dev/null && echo "bandit OK" || echo "bandit missing"
which semgrep 2>/dev/null && echo "semgrep OK" || echo "semgrep missing"
which cppcheck 2>/dev/null && echo "cppcheck OK" || echo "cppcheck missing"
which trivy 2>/dev/null && echo "trivy OK" || echo "trivy missing"
```

Install missing tools if needed (ask user before installing):
```bash
uv tool install bandit       # Python static analysis
pip install semgrep          # Multi-language SAST
brew install cppcheck        # C++ static analysis
brew install trivy           # Dependency vulnerability scanner
```

---

## Step 2: Run Automated Scanners

### Python — bandit
```bash
bandit -r . -f json -o /tmp/bandit_report.json --exclude './.venv,./tests' 2>&1
bandit -r . -ll --exclude './.venv,./tests'   # Show HIGH+ issues inline
```

### Python + C++ — semgrep
```bash
semgrep --config "p/python" --config "p/security-audit" \
        --config "p/secrets" --config "p/owasp-top-ten" \
        --json -o /tmp/semgrep_report.json \
        --exclude "*.venv" --exclude "build/" .
```

### C++ — cppcheck
```bash
cppcheck --enable=all --inconclusive --std=c++17 \
         --suppress=missingIncludeSystem \
         --xml --xml-version=2 \
         . 2>/tmp/cppcheck_report.xml
```

### Dependencies — trivy
```bash
# Python dependencies
trivy fs --scanners vuln . 2>&1 | head -80

# Check for known-bad packages
pip list --format=json | python3 -c "
import json, sys
pkgs = json.load(sys.stdin)
print('\n'.join(f\"{p['name']}=={p['version']}\" for p in pkgs))
" > /tmp/installed_packages.txt
```

---

## Step 3: Manual Pattern Scans

Run these grep-based checks even without automated tools:

### Hardcoded Secrets
```bash
grep -rn --include="*.py" --include="*.cpp" --include="*.h" --include="*.yaml" --include="*.json" \
  -E '(password|passwd|secret|api_key|apikey|token|auth_token|access_key|private_key)\s*=\s*["\x27][^"\x27]{6,}' \
  --exclude-dir='.git' --exclude-dir='.venv' --exclude-dir='build' .

# AWS/GCP/HuggingFace tokens
grep -rn -E '(AKIA[0-9A-Z]{16}|sk-[a-zA-Z0-9]{48}|hf_[a-zA-Z0-9]{36,}|ghp_[a-zA-Z0-9]{36,})' \
  --exclude-dir='.git' .
```

### Command Injection (Python)
```bash
grep -rn --include="*.py" \
  -E '(subprocess\.(call|run|Popen|check_output)\s*\([^)]*shell\s*=\s*True|os\.system\s*\(|eval\s*\(|exec\s*\()' \
  --exclude-dir='.venv' .
```

### SQL Injection (Python)
```bash
grep -rn --include="*.py" \
  -E '(execute\s*\(\s*[f"'\''"]|execute\s*\(\s*\%|\+\s*["\x27]\s*WHERE|cursor\.execute.*%s.*%\s*[^(])' \
  --exclude-dir='.venv' .
```

### Unsafe Deserialization (Python)
```bash
grep -rn --include="*.py" \
  -E '(pickle\.loads?|pickle\.load|yaml\.load\s*\([^,)]+\)(?!.*Loader)|jsonpickle\.decode|marshal\.loads?)' \
  --exclude-dir='.venv' .
```

### Path Traversal (Python)
```bash
grep -rn --include="*.py" \
  -E '(open\s*\(\s*[^)]*\+|os\.path\.(join|abspath)\s*\([^)]*request\.|send_file\s*\()' \
  --exclude-dir='.venv' .
```

### Memory Safety (C++)
```bash
grep -rn --include="*.cpp" --include="*.h" \
  -E '(strcpy\s*\(|strcat\s*\(|sprintf\s*\(|gets\s*\(|scanf\s*\(\s*"%s"|malloc\s*\([^)]*sizeof.*\)\s*\*|memcpy\s*\([^,]+,[^,]+,[^)]*\+)' \
  --exclude-dir='build' .

# Raw pointer without null check
grep -rn --include="*.cpp" \
  -E '\*\s*[a-zA-Z_]+\s*[^=!]' \
  --exclude-dir='build' . | head -30
```

### Insecure Random (Python)
```bash
grep -rn --include="*.py" \
  -E '(import random|from random import|random\.random\(\)|random\.randint\()' \
  --exclude-dir='.venv' . | grep -v '# nosec'
```

### TLS/SSL Issues (Python)
```bash
grep -rn --include="*.py" \
  -E '(verify\s*=\s*False|ssl\._create_unverified_context|CERT_NONE|check_hostname\s*=\s*False)' \
  --exclude-dir='.venv' .
```

---

## Step 4: Report Format

Present findings in this format:

```
## Security Scan Report — <date>

### CRITICAL
| # | File:Line | Issue | CWE |
|---|-----------|-------|-----|
| 1 | src/auth.py:42 | Hardcoded API key | CWE-798 |

**Finding 1** — `src/auth.py:42`
**Issue:** Hardcoded API key in source code
**Risk:** Credential exposure via version control
**Current code:**
    API_KEY = "sk-abc123..."

**Fixed code:**
    import os
    API_KEY = os.environ["API_KEY"]  # Set via env or secrets manager

---

### HIGH
...

### MEDIUM
...

### LOW / INFORMATIONAL
...

## Summary
- CRITICAL: N
- HIGH: N
- MEDIUM: N
- LOW: N
- Files scanned: N
- Tools used: bandit, semgrep, manual grep
```

---

## Common Fixes Reference

### Hardcoded Secrets → Environment Variables
```python
# BEFORE (bad)
API_KEY = "hf_abc123xyz"

# AFTER (good)
import os
API_KEY = os.environ.get("API_KEY") or raise ValueError("API_KEY not set")
# Or with python-dotenv:
from dotenv import load_dotenv
load_dotenv()
API_KEY = os.environ["API_KEY"]
```

### Command Injection → subprocess with list args
```python
# BEFORE (bad)
import subprocess
subprocess.call(f"convert {user_input} output.png", shell=True)

# AFTER (good)
import subprocess, shlex
subprocess.run(["convert", user_input, "output.png"], check=True)
```

### SQL Injection → Parameterized Queries
```python
# BEFORE (bad)
cursor.execute(f"SELECT * FROM users WHERE id = {user_id}")

# AFTER (good)
cursor.execute("SELECT * FROM users WHERE id = ?", (user_id,))
```

### Unsafe YAML → Safe Loader
```python
# BEFORE (bad)
import yaml
data = yaml.load(stream)  # executes arbitrary Python!

# AFTER (good)
data = yaml.safe_load(stream)
# Or explicitly:
data = yaml.load(stream, Loader=yaml.SafeLoader)
```

### Unsafe Pickle → JSON or msgpack
```python
# BEFORE (bad)
import pickle
obj = pickle.loads(user_data)

# AFTER (good) — use JSON for simple data
import json
obj = json.loads(user_data)
# For numpy arrays in ML context:
import numpy as np
arr = np.load(path, allow_pickle=False)
```

### C++ Buffer Overflow → Safe Alternatives
```cpp
// BEFORE (bad)
char buf[64];
strcpy(buf, user_input);

// AFTER (good)
std::string buf = user_input;  // Use std::string
// Or if C-style needed:
strncpy(buf, user_input, sizeof(buf) - 1);
buf[sizeof(buf) - 1] = '\0';
```

### Insecure Random → secrets module (crypto use)
```python
# BEFORE (bad) — for tokens/keys
import random
token = random.randbytes(32)

# AFTER (good)
import secrets
token = secrets.token_bytes(32)
token_hex = secrets.token_hex(32)
```

### SSL Verification → Always verify
```python
# BEFORE (bad)
requests.get(url, verify=False)

# AFTER (good)
requests.get(url, verify=True)  # default, explicit
# If custom CA:
requests.get(url, verify="/path/to/ca-bundle.crt")
```

---

## NPU/ML-Specific Checks

### Model Loading Security
```bash
# Check for unsafe model loading (pickle-based formats)
grep -rn --include="*.py" \
  -E '(torch\.load\s*\([^)]*\)|pickle\.load|np\.load.*allow_pickle\s*=\s*True)' .
```
**Fix:** Always use `weights_only=True` for PyTorch:
```python
# AFTER (good)
model = torch.load(path, weights_only=True, map_location="cpu")
```

### Shared Memory / IPC Security (NPU SDK)
```bash
grep -rn --include="*.py" --include="*.cpp" \
  -E '(shm_open|mmap\s*\(|shared_memory\.SharedMemory)' .
```
Check that shared memory segments are properly cleaned up and have appropriate permissions (avoid `0777`).

### Logging Sensitive Data
```bash
grep -rn --include="*.py" \
  -E '(logger\.(debug|info|warning|error)\s*\([^)]*\b(password|token|secret|key)\b)' .
```

---

## Suppression (nosec / noqa)

When a finding is a false positive, suppress inline with context:
```python
token = base64.b64decode(encoded)  # nosec B64  — not a secret, just encoding
random.seed(42)  # nosec B311 — reproducibility seed, not security use
```
Document *why* it's suppressed in the same comment.
