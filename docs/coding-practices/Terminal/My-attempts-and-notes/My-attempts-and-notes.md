---
title: My attempts and notes
layout: default
parent: Terminal 
grand_parent: Coding Practices
---
# Personal Notes or My Attempts
{: .no_toc }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

# Setting up
## Setting up maven in ubuntu
1. Install maven using `apt`
``` bash
sudo apt update && sudo apt install maven 
```
Enter sudo password, Type Y if needed

2. Please check with `mvn -v` after installation

3. Since this mvn comes with jdk 11, we need to update to jdk 22
Try `wget https://download.oracle.com/java/22/latest/jdk-22_linux-x64_bin.deb`

4. Then try sudo apt install jdk22
`sudo apt install ./jdk-22_linux-x64_bin.deb`

5. Check with `java -version` taht your java version is now on 22.0.1!

6. Please reun `mvn clean install -Dmaven.test.skip=true`

## Using crontab to purge RAM and disk cache routinely (MacOS version)
1. `sudo crontab -l` check what crontab is running
2. `sudo crontab -e` and add the following lines
3. 
```bash
## Check MacOS sudo crontab log with this command:
## sudo log show --predicate 'process == "cron"' --info

## Clear Disk Cache (sudo purge)
* * * * * sudo purge

## Cler RAM Cache (every hour)
0 * * * * rm -rf ~/Lib/Caches/*
```

4. Extra: You can use this bash script to check the logs for running your crontabs
```bash
sudo log show --predicate 'process == "cron"' --info
```