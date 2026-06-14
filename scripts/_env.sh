# Shared environment for ferrum-meta shell scripts.
# Suppress noisy third-party warnings that are not actionable in this repo.
export PYTHONWARNINGS="${PYTHONWARNINGS:-ignore::urllib3.exceptions.NotOpenSSLWarning}"
