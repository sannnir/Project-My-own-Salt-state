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

### Tasks

1. Create virtual machines and install a Salt master-minion architecture.
2. Download Git, Micro and Netcat to master
3. Copy each programs source list to this salt-project folder and create the init.sls-file
4. Try the salt state locally first then to the minions.



### 1. Create virtual machines and install a Salt master-minion architecture

As a master I am going to use Ubuntu (version 22.04.1) virtual machine that I have created earlier. But I'm going to create few minions so that I can really test my salt-state on them.

By creating minions I'm going to use Vagrant which I already have on my host-computer. Vagrant is an open-source tool that helps you create virtual environments super easily. It is recommend to install Vagrant to your host computer. Vagrant also need a hypervisor, which can be VirtualBox, to be able to create virtual machines. Vagrant uses boxes which are like operating system images that it clones to the new VM. (Vagrant 2022.) You can find different boxes [here](https://app.vagrantup.com/boxes/search).

#### Master (Ubuntu):
First I deleted SaltStack from my master so that I could start over.

        sudo apt purge salt-master
        sudo apt purge salt-minion

Little test and the result is that I don't have Salt on my computer.

<img width="277" alt="image" src="https://user-images.githubusercontent.com/117899949/206404447-7ad15a3e-be7a-44e4-93f8-8f3271bee6c3.png">

Let's start by making updates `sudo apt update/sudo apt upgrade` and then installing the Salt master.

        sudo apt -y install salt-master

Little test to see that Salt-master has been installed: 

<img width="365" alt="image" src="https://user-images.githubusercontent.com/117899949/206406814-53e78762-8e65-49bf-8b53-18b48738fb6a.png">

Then I'll check the hostname ip from the master so that I am able to manage the minions later on.

        hostname -I

<img width="223" alt="image" src="https://user-images.githubusercontent.com/117899949/206407443-0c49f8c8-19c0-4234-b35f-656ec0110e9a.png">


#### Minions:

Now we are going to need some minions. 
I am going to create 3 Virtual Machines by using Vagrant.

Since I have already installed Vagrant to my host computer (Windows 11 Home) I am going to skip that phase. Let's open Windows PowerShell and create a new folder for Vagrantfile where I am going to qualify the amount of VMs and also tell which OS box they are going to have. Instructions for creating that file are from [here](https://terokarvinen.com/2021/two-machine-virtual-network-with-debian-11-bullseye-and-vagrant/).




4.
Testing locally that my salt-state works
I first deleted all the files (git, micro, netcat) because I got them all on my master.

    sudo apt purge micro
    sudo apt purge git
    sudo apt purge netcat

After that I tried to open each one of the programs above but I got the following the error message:
"/usr/bin/git: No such file or directory"

Then I tried to run the salt-state locally

  salt-call --global state.apply TESTI

And after that when I opened micro, it was there! As well as git and netcat too. 



*****
#### Sources:

SaltStack 2022. Salt.State.Pkg. URL: https://docs.saltproject.io/en/latest/ref/states/all/salt.states.pkg.html. Accessed: 7.12.2022

Tero Karvinen 2018. Salt Quickstart - Salt Stack Master and Slace on Ubuntu Linux. URL: https://terokarvinen.com/2018/salt-quickstart-salt-stack-master-and-slave-on-ubuntu-linux/. Accessed: 8.12.2022

Vagrant 2022. Development environments made easy. URL: https://www.vagrantup.com/. Accessed: 8.12.2022
