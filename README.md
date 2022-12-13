# Project: My own Salt-state

### Salt state: Git - Micro 

In this project I'm going to create a Salt-state by using SaltStack. My Salt-state will download the following files to the minion-virtual machines:
- Git
- Micro

This project is part of the course called "Configuration Management Systems - Palvelinten Hallinta" by Tero Karvinen. You can find more information about this course and the project assignment from [here](https://terokarvinen.com/2022/palvelinten-hallinta-2022p2/). 

I'll be using Virtual Machines on Virtual Box. I am going to create a Salt-master and then a Salt-minion by using Vagrant.
That will be the environment where I'm going to test my Salt state.

Git and Micro were selected because we have used them a lot during this course and I have found them very useful. This is why I felt it would be nice to try to figure out how to get them to the devices at once instead of doing the downloading manually to each of the vm's.
Git and Micro are also files that are not included to Linux based operation systems by default.

You can find all the sources used in this project at the end of this file.

### Environment

- Host-computer: Microsoft Windows 11 Home (version 10.0.22621 N/A Build 22621)
- Vagrant (version 2.3.3)
- Virtual Box (version 6.1)

### Tasks

1. Create virtual machines and install a Salt master-minion architecture.
2. Create a Salt state
3. Try the salt state locally first and then to the minions.


### 1. Create virtual machines and install a Salt master-minion architecture

As a master and a minion I am going to create two virtual machines with the help of Vargant so that I can really test my salt-state on them.

Since I have already installed Vagrant to my host computer (Windows 11 Home) I am going to skip "Install Vagrant"-phase. Vagrant is an open-source tool that helps you create virtual environments super easily. It is recommend to install Vagrant to your host computer. Vagrant also needs a hypervisor, which can be VirtualBox, to be able to create virtual machines. Vagrant uses boxes which are like operating system images that it clones to the new VM. (Vagrant 2022.) You can find different boxes [here](https://app.vagrantup.com/boxes/search).

#### Virtual Machines:

When using Vagrant with Windows the easiest way is to open Windows PowerShell. So let's open PowerShell and create a new folder for Vagrantfile where I am going to qualify the amount of VMs and also tell which OS box they are going to have. Instructions of creating that Vagrantfile are from [here](https://terokarvinen.com/2021/two-machine-virtual-network-with-debian-11-bullseye-and-vagrant/).

First I created `vkoneet` folder where I was going to create the Vagrantfile. I used notepad for creating the Vagrantfile.

        mkdir vkoneet
        cd ./vkoneet/
        notepad.exe Vagrantfile

<img width="347" alt="image" src="https://user-images.githubusercontent.com/117899949/206437522-486bdfca-d6f4-400e-9784-55e2cc94562d.png">

In Vagrantfile I am going to use `debian/bullseye64` box, which will be installing Debian 11 OS to the virtual machines. Then there are both of the virtual machines `t001` and `t002` configured, where t001 is going to be the master and t002 minion. 

###### Note: You could change the names "t001" to "master" or "minion" etc. but I was lazy and kept them like that.

<img width="532" alt="image" src="https://user-images.githubusercontent.com/117899949/206436866-933b277d-1be3-45d1-b7f4-3684dda61c9e.png">

Then I will create the VMs by giving a command `vagrant init Vagrantfile`. 

###### Note: on Windows notepad will create a Vagrantfile as Vagrantfile.txt format. Make sure the name is just `Vagrantfile` without the .txt. This mistake happened to me and I had to change the make manully after I created this file.

        vagrant init Vagrantfile

Then we are ready to start them by command:

        vagrant up


<img width="575" alt="image" src="https://user-images.githubusercontent.com/117899949/206442534-3ca699d9-3133-4b8c-89f7-4a4b1c05fa48.png">

And just like that - I have two virtual machines! One master and one minion:

<img width="221" alt="image" src="https://user-images.githubusercontent.com/117899949/207284438-2bd7f9c4-4964-4502-80a5-88788d3f67b4.png">

At this point I am goint to make a ping-test from t001 to t002 just to see that the connections between them is ok.

With Vagrant you can take SSH connection to VMs by command:

        vagrant ssh <computername>

        vagrant ssh t001
        ping 192.168.88.102
        exit
        
It works. Our test-environment is now ready.

<img width="366" alt="image" src="https://user-images.githubusercontent.com/117899949/207284957-1df89089-12ef-48c3-a90b-0bb51dfc594c.png">

        
#### Master (Debian 11): 
        
Since our environment is ready, let's create the SaltStack master-minion architecture.
I'm going to start by making updates `sudo apt update` to t001 and then installing the Salt master.

        sudo apt -y install salt-master

At this point I'll make a little test to see that Salt-master has been installed: 

<img width="449" alt="image" src="https://user-images.githubusercontent.com/117899949/207285729-c353f3b7-868d-41b3-973c-d0b1db8d89cf.png">

Then I'll check the hostname ip from the master so that I am able to manage the minion(s) later on.

        hostname -I

<img width="197" alt="image" src="https://user-images.githubusercontent.com/117899949/207285804-dab4b358-6cdd-422f-843e-c7171d26fb8f.png">

The last thing is to check that the ports 4505/tcp and 4506/tcp are open on master. 

        ss -lntu

<img width="585" alt="image" src="https://user-images.githubusercontent.com/117899949/207285937-589f7467-4c46-463d-bc7d-96e7daefe99d.png">

This looks ok. Master is listening those ports.

#### Minion (Debian 11):

Still using the Vagrant and repeating the same things to minion as I did to master earlier. Only this time I will install `Salt-minion` to my minion.

        vagrant ssh t002
        sudo apt update
        sudo apt -y install salt-minion
 
Next I need to tell my minion, who's the boss.
I'll go to the the minion file and add the master's ip-address to the file. Minion file will be at `etc/salt`

        sudoedit /etc/salt/minion
        
<img width="261" alt="image" src="https://user-images.githubusercontent.com/117899949/207286884-7cc9b0ab-7cba-4225-b340-52954aaa0e32.png">

<img width="434" alt="image" src="https://user-images.githubusercontent.com/117899949/207286808-b798f201-8d30-414b-9468-8e4143092fe8.png">

After changing the file you have to restart the Salt-minion.

        sudo systemctl restart salt-minion.service
        exit

#### Master: 

Now we need to go back to master and check if there are keys to be accepted so that the deal is sealed.

        sudo salt-key           (to check them out)
        sudo salt-key -A        (to accept them)
        
<img width="201" alt="image" src="https://user-images.githubusercontent.com/117899949/207290203-595a67b4-38c1-4399-b68e-1ab4d39c8a45.png">

Then little `salt '*' cmd.run 'whoami'` -test just to check that our minion is talking to us:
<img width="344" alt="image" src="https://user-images.githubusercontent.com/117899949/207037387-82947cf9-fdf0-48f7-acf8-27835fdd6323.png">

All good.

## 2. Create a Salt state

#### Master:

Let's start by creating a folder for the states

        sudo mkdir /srv/salt/
       
First I will start with easy one: hello world test just to see this works.

        sudoedit hello.sls

Creating the state:
<img width="323" alt="image" src="https://user-images.githubusercontent.com/117899949/207039397-e690e0b8-3cad-444a-82f6-c5b4f986636e.png">

Then I made a helloworld.txt file with a simple content of "Hello World!!"

Applying the hello-state:
<img width="398" alt="image" src="https://user-images.githubusercontent.com/117899949/207039456-6ca863ce-6dc5-46e3-91f8-966fb2b7e38b.png">

Little test to see if our minion got it:
<img width="461" alt="image" src="https://user-images.githubusercontent.com/117899949/207040993-c3cc7d5b-0a39-436a-810c-39bbb945cd70.png">

All good, so we can move on to creating our own state.

*****

I wanted to create a state that installs the following programs:
- Git
- Micro

First I checked that I don't have those on my master:

All good, nothing here:
<img width="370" alt="image" src="https://user-images.githubusercontent.com/117899949/207050535-86e999a3-e232-40e6-9e44-e060c90b74bb.png">

Then I created a new folder `sudo mkdir ownstate`

        sudo mkdir ownstate
        cd ownstate
        sudoedit init.sls
        
Sudoedit opens a Nano editor. I added the path and then the packages:

        #/srv/salt/ownstate/init.sls
        mypkgs:
          pkg.installed:
            - pkgs:
              - git
              - micro
              
<img width="247" alt="image" src="https://user-images.githubusercontent.com/117899949/207050743-7bb927a1-d3bc-43ff-b912-532f13b5b4e7.png">

All righty then, let's move on.

## 3. Try the salt state locally first and then to the minions.

Now we are ready to do testings. I tested it locally first.

<img width="454" alt="image" src="https://user-images.githubusercontent.com/117899949/207052027-0244f579-be5c-47e8-a82f-54b54b66cf24.png">

Micro can be found when opening inis.sls file with micro `micro init.sls`:

<img width="253" alt="image" src="https://user-images.githubusercontent.com/117899949/207052130-1febcfc8-7743-4469-88be-f15a2ca807d5.png">

And git also:

<img width="472" alt="image" src="https://user-images.githubusercontent.com/117899949/207052211-6258e8c5-d8b3-4d78-8a74-0c3cdf187e92.png">

Let's run this state to minion too.

        sudo salt '*' state.apply ownstate

<img width="488" alt="image" src="https://user-images.githubusercontent.com/117899949/207052751-bffcfcf4-fd6f-43ca-857a-300b1602b885.png">

Then I'll check if minion has those two too.

<img width="362" alt="image" src="https://user-images.githubusercontent.com/117899949/207052889-a1c33df9-f465-413b-a5a4-9dd6cbe45485.png">

Minion t002 looks ok with both git and micro

Git:

<img width="465" alt="image" src="https://user-images.githubusercontent.com/117899949/207053004-37528e92-0b8b-42b5-929e-d5dd9483d455.png">

Micro:

<img width="311" alt="image" src="https://user-images.githubusercontent.com/117899949/207053216-924baa8d-03b1-426b-ac3c-a83db4eebb87.png">



*****
*****
## Sources:

phoenixNAP 2022. How To Use Linux SS Command. URL: https://phoenixnap.com/kb/ss-command. Accessed: 12.12.2022

SaltStack 2022. Salt.State.Pkg. URL: https://docs.saltproject.io/en/latest/ref/states/all/salt.states.pkg.html. Accessed: 7.12.2022

Tero Karvinen 2017. Vagrant Revisited – Install & Boot New Virtual Machine in 31 seconds. URL: https://terokarvinen.com/2017/04/11/vagrant-revisited-install-boot-new-virtual-machine-in-31-seconds/?fromSearch=vagrant Accessed: 12.12.2022

Tero Karvinen 2018. Salt States – I Want My Computers Like This. URL: https://terokarvinen.com/2018/salt-states-i-want-my-computers-like-this/?fromSearch=salt. Accessed: 12.12.2022

Tero Karvinen 2018. Salt Quickstart - Salt Stack Master and Slace on Ubuntu Linux. URL: https://terokarvinen.com/2018/salt-quickstart-salt-stack-master-and-slave-on-ubuntu-linux/. Accessed: 8.12.2022

Tero Karvinen 2021. Two Machine Virtual Network With Debian 11 Bullseye and Vagrant. URL: https://terokarvinen.com/2021/two-machine-virtual-network-with-debian-11-bullseye-and-vagrant/. Accessed: 12.12.2022

Vagrant 2022. Development environments made easy. URL: https://www.vagrantup.com/. Accessed: 8.12.2022

Vagrant 2022. Discover Vagrant Boxes. URL: https://app.vagrantup.com/boxes/search. Accessed: 7.12.2022

