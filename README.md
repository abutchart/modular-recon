# modular-recon
A set of modular reconnaissance scripts to capture data on bug bounty target domains.

![image](https://user-images.githubusercontent.com/54566106/168514419-d2a67d09-6ba7-42df-83d7-416ad18237ea.png)

## Installation
Clone this repo:
`git clone https://github.com/brianbutchart/modular-recon.git`

The following tools must be installed: 
- [hakrawler](https://github.com/hakluke/hakrawler)
- [ffuf](https://github.com/ffuf/ffuf)
- [amass](https://github.com/OWASP/Amass)
- [subfinder](https://github.com/projectdiscovery/subfinder)
- [httprobe](https://github.com/tomnomnom/httprobe)
- [nuclei](https://github.com/projectdiscovery/nuclei)
- [nitko](https://github.com/sullo/nikto)
- [EyeWitness](https://github.com/FortyNorthSecurity/EyeWitness)

nikto can be installed with `pacman -S nikto` on Arch. Other options exist for other OS's, check the linked repo. 

Follow the instructions on the installation guide to install EyeWitness. Make sure that the EyeWitness directory is inside of the modular-recon directory. Rename it to EyeWitness if it downloads with a different name.

The rest of the tools use go. Install go and run the following commands:
```
go install github.com/hakluke/hakrawler@latest
go install github.com/ffuf/ffuf@latest
go install -v github.com/OWASP/Amass/v3/...@master
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
go install -v github.com/tomnomnom/httprobe@master
go install -v github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest
```

## Usage
Each module takes either standard input or a text file as input, and outputs to standard output. This can be piped into whatever you require.

Modules starting with "controller" run other modules in a sequence to perform a task.

`controller_bug_bounty.sh` downloads bug bounty data from [bounty-targets-data](https://github.com/arkadiyt/bounty-targets-data), formats it, enumerates subdomains, verifies these subdomains, takes screenshots, scans for vulnerabilities, and enumerates files.

The other controllers perform roughly the same actions but get input in the format `controller.sh targets.txt target_dir`. The controller script will then go on to store all of its data in a directory with the name specified. "no_subs" means that the controller does not enumerate subdomains. "subs" means it does. A "heavy" controller will perform more thorough checks but will be slower and noisier than a "light" controller.

Non-controller modules may have numbers. Like the distinction between "light" and "heavy", the higher the number, the more thorough (but slower and noiser) the script will be. 
