# Prerequisites 
To use the virtual machine, two pieces of software need to be installed: Docker, and Vagrant

Both packages can very easily be installed using their official installation instructions.

Docker Desktop can be download from here:
https://docs.docker.com/get-docker/

Vagrant is avaliable here:
https://www.vagrantup.com/downloads

# Clone repository

```
git clone https://github.com/aardk/difmap2022.git
```

# Usage
```
cd difmap2022
vagrant up
vagrant ssh
```

This will start a virtual machine and open a shell within the virtual machine over SSH. If you get a Docker related error, make sure that Docker Desktop is running on your machine.

Now that you are in the virtual machine, you can start difmap by typing:
```
cd data
difmap
```
