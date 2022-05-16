# modular-recon
A set of modular reconnaissance scripts to capture data on bug bounty target domains
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

