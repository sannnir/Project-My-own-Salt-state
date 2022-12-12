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

As a master I am going to a virtual machine with the help of Vargant. I'm also going to create two minions too so that I can really test my salt-state on them.

By creating VMs I'm going to use Vagrant which I already have on my host-computer. Vagrant is an open-source tool that helps you create virtual environments super easily. It is recommend to install Vagrant to your host computer. Vagrant also need a hypervisor, which can be VirtualBox, to be able to create virtual machines. Vagrant uses boxes which are like operating system images that it clones to the new VM. (Vagrant 2022.) You can find different boxes [here](https://app.vagrantup.com/boxes/search).

#### Master (Debian 11):
First I created a vms folder to create the VM. I created Debian 11 with the box `debian/bullseye64`. 

        vagrant init debian/bullseye64
        vagrant up

<img width="416" alt="image" src="https://user-images.githubusercontent.com/117899949/206994665-4e9581c2-23d3-4d69-b5eb-7c385da9fde8.png">

I'll take a ssh connection with Vagrant to my new VM:
        
        vagrant ssh
        
Let's start by making updates `sudo apt update/sudo apt upgrade` and then installing the Salt master.

        sudo apt -y install salt-master

Little test to see that Salt-master has been installed: 

<img width="447" alt="image" src="https://user-images.githubusercontent.com/117899949/206995010-0478a089-74fd-4a0b-a036-345f607330c5.png">

Then I'll check the hostname ip from the master so that I am able to manage the minions later on.

        hostname -I

<img width="243" alt="image" src="https://user-images.githubusercontent.com/117899949/206995094-197f1c8e-5c8e-438a-b18f-d45308347190.png">

The last thing is to check that the ports 4505/tcp and 4506/tcp are open.

        ss -lntu

<img width="499" alt="image" src="https://user-images.githubusercontent.com/117899949/206998740-c5527652-8a5e-40cf-823f-c9152d79ccfa.png">

This looks ok. Master is listening those ports.

#### Minions:

Now we are going to need some minions. 
I am going to create two Virtual Machines by using Vagrant.

Since I have already installed Vagrant to my host computer (Windows 11 Home) I am going to skip "Install Vagrant"-phase. Let's open Windows PowerShell and create a new folder for Vagrantfile where I am going to qualify the amount of VMs and also tell which OS box they are going to have. Instructions of creating that Vagrantfile are from [here](https://terokarvinen.com/2021/two-machine-virtual-network-with-debian-11-bullseye-and-vagrant/).

Open PowerShell, create a folder, go there and create a file.
        
        mkdir vkoneet
        cd ./vkoneet/
        notepad.exe Vagrantfile

<img width="347" alt="image" src="https://user-images.githubusercontent.com/117899949/206437522-486bdfca-d6f4-400e-9784-55e2cc94562d.png">

In Vagrantfile I am going to use debian/bullseye64 box, which will install Debian 11 OS to the minion vms.

<img width="532" alt="image" src="https://user-images.githubusercontent.com/117899949/206436866-933b277d-1be3-45d1-b7f4-3684dda61c9e.png">


Then I will crete the VMs by giving a command `vagrant init Vagrantfile`. 
Note: on Windowds notepad will create a Vagrantfile as Vagrantfile.txt format. Make sure the name is just `Vagrantfile` without the .txt. This mistake happened to me and I had to change the make manully after I created this file.

        vagrant init Vagrantfile

Then we are ready to start them by command:

        vagrant up
        
<img width="575" alt="image" src="https://user-images.githubusercontent.com/117899949/206442534-3ca699d9-3133-4b8c-89f7-4a4b1c05fa48.png">

And now I have three VMs in total. One master and two becoming minions:

<img width="188" alt="image" src="https://user-images.githubusercontent.com/117899949/207007847-50bc6cc3-4350-49e4-a994-a685b6630b97.png">

At this point I am goint to make a ping-test from t001 and t002 to master just to see that the connections between them is ok.

With Vagrant you can take SSH connection to VMs by command:

        vagrant ssh <computername>

        vagrant ssh t001
        ping 10.0.2.15
        exit
        
        vagrant ssh t002
        ping 10.0.2.15
        exit
        
It works. 

<img width="440" alt="image" src="https://user-images.githubusercontent.com/117899949/206446173-9f57cf61-8778-46c9-88c0-04845f737e6e.png">
<img width="415" alt="image" src="https://user-images.githubusercontent.com/117899949/206446364-9f655aa5-3f8b-4599-8ef6-f89f3bb79ecb.png">


Next I'm going to update t001 and t002, install Salt-minions to them and add master's ip address to the minion-file so that the minions will know who will manage them. 

        vagrant ssh t001
        sudo apt update
        sudo apt -y install salt-minion
        
Then I can go the the minion file and add the master's ip-address to the file. Minion file will be at `etc/salt`
        
<img width="304" alt="image" src="https://user-images.githubusercontent.com/117899949/206448789-376f9b6b-712a-4770-a579-dfa34839882a.png">

<img width="412" alt="image" src="https://user-images.githubusercontent.com/117899949/207006160-e2ed0448-d8a4-4499-82f0-f8eb087aff09.png">

After changing the file you have to restart the Salt-minion.

        sudo systemctl restart salt-minion.service
        exit

Then I'll repeat this same thing to the t002 too.

Only this left is to confirm the keys on master.
So lets go back to our master and check if there are keys to be accepted

        sudo salt-key 

<img width="194" alt="image" src="https://user-images.githubusercontent.com/117899949/207006820-05118f32-e487-4424-8d5b-39f5cd08a16e.png">

#### *Plot twist:* 
So the keys were empty. 
I didn't know how to fix this and got stuck. After two days of googling the problem I still didn't get this. Time was running out so I had to start over and do this again with only two VMs.





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

https://unixcop.com/how-to-open-ports-in-ubuntu-debian/
