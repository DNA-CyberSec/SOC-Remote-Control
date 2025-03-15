# 🚀 SOC Remote Control – Automated Cyber Operations

![GitHub repo size](https://img.shields.io/github/repo-size/DNA-CyberSec/SOC-Remote-Control)
![GitHub contributors](https://img.shields.io/github/contributors/DNA-CyberSec/SOC-Remote-Control)
![License](https://img.shields.io/github/license/DNA-CyberSec/SOC-Remote-Control)

SOC Remote Control is an advanced Bash script designed to automate remote control, scanning, and reconnaissance tasks, enhancing security operations and red-team activities with a high level of anonymity and logging.

---

## 📌 Features

- 🔐 **Automatic SSH Connection** – Securely connect and execute remote commands.
- 🌎 **Anonymity Check** – Ensures operations are performed anonymously.
- 🔍 **Information Gathering** – Automated scanning (Nmap) and WHOIS lookups.
- 📝 **Detailed Reporting** – Generates logs and audits all activities clearly.
- 📂 **Structured Logs** – Records user actions, timestamps, and results systematically.
- 🛠️ **Dependency Management** – Automatically checks and installs essential tools.

---

## 🎯 Usage

Clone this repository:

```bash
git clone https://github.com/DNA-CyberSec/SOC-Remote-Control.git
cd SOC-Remote-Control
chmod +x soc_remote_control.sh
```

### Run the script:

```bash
./soc_remote_control.sh
```

Follow the interactive prompts to execute the desired actions.

---

## 📦 Tools & Dependencies

The script automatically checks and installs:

- SSHpass (For automated SSH login)
- Nmap (Network scanning)
- Whois (Domain and IP information)
- Tor & Nipe (Anonymity and spoofing checks)

---

## 📂 Project Structure

```
SOC-Remote-Control/
├── 📂 logs/
│   └── 📑 activity.log
├── 🖥️ soc_remote_control.sh
└── 📖 README.md
```

---

## 🔐 Security Notice

This tool is designed for educational purposes and authorized penetration testing only. Do not use against systems without explicit permission.

---

## 📜 License

This project is licensed under the MIT License – see the [LICENSE](LICENSE) file for details.

---

## 🧑‍💻 Author

- **Rami Hacmon** – [GitHub Profile](https://github.com/DNA-CyberSec)

Feel free to contribute, fork, or open issues!

⭐ **Star this repository if you find it helpful!**
