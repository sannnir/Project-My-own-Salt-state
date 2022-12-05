# Project: My own Salt-state

### Salt state: Git - Micro - Netcat

In this project I'm going to create a Salt-state by using SaltStack. My Salt-state will download the following files to the minion-virtual machines:
- Git
- Micro
- Netcat

This project is part of the course called "Configuration Management Systems - Palvelinten Hallinta" by Tero Karvinen. You can find more information about this course and the project assignment from [here](https://terokarvinen.com/2022/palvelinten-hallinta-2022p2/). 

I'll be using Virtual Machines on Virtual Box. I am going to create a Salt-master and then few Salt-minions by using Vagrant.
That will be the environment where I'm goint to test my Salt state.

Git, Micro and Netcat were selected because we have used them a lot during this course and I have found them very useful. This is why I felt it would be nice to try to figure out how to get them to the devices at once instead of doing the downloading manually to each of the vm's.
Git, Micro and Netcat are also files that are not included to Linux based operation systems by default.

You can find all the sources used in this project at the end of this file.

### Environment

- Host-computer: Microsoft Windows 11 Home (version 10.0.22621 N/A Build 22621)
- Vagrant (version 2.3.3)
- Virtual Box (version 6.1)

