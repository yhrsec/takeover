# 🛡️ Advanced Subdomain Takeover Automation Tool

A powerful Bash automation script to detect vulnerable subdomains using `httpx` and `subzy`.

---

## 🚀 Features

- Detects subdomains with vulnerable HTTP responses (400, 404, 500)
- Extracts and filters CNAMEs
- Cleans domain list and runs automated takeover check
- Colorful CLI output and progress tracking

---

## 🔧 Requirements

Make sure the following tools are installed:

### 1. Golang
```bash
sudo mv takeover.sh /usr/local/bin/takeover
