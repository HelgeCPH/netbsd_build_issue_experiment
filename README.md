#

I have a problem building NetBSD 11 from source on.


## To conduct the experiment

To conduct the experiment of building NetBSD 11 locally on your computer, you need to clone this repository: 

```bash
git clone git@github.com:HelgeCPH/netbsd_build_issue_experiment.git¨
```

To run the experiment directly on your computer, i.e., _bare metal_ do 

```bash
cd bare_metal
chmod u+x *.sh


```

Dependencies:
- VirtualBox
- vagrant
- vagrant-ssh


Since executable bits are not preserved when cloning repositories from GitHub, make the scripts for this experiment executable

```
chmod u+x collect_host_info.sh
chmod u+x build_tools.sh
chmod u+x build_release.sh
```

In the root of this repository, you need the NetBSD sources from the Git mirror on Github.
I conducted the experiment on this version: <https://github.com/NetBSD/src/tree/4198f5370c187384b1de46b9b0fcd04462a420e0>
To get this version of the NetBSD sources create a shallow clone:

- with `git` (version >= 2.49.0):
  ```
  git clone --depth 1 --revision 4198f5370c187384b1de46b9b0fcd04462a420e0 https://github.com/NetBSD/src.git
  ```
- with `git` (version < 2.49.0):
  ```
  mkdir netbsd-src-11
  cd netbsd-src-11
  git init
  git remote add origin https://github.com/NetBSD/src.git
  git fetch --depth 1 origin 4198f5370c187384b1de46b9b0fcd04462a420e0
  git checkout FETCH_HEAD
  ```

Currently, the Vagrantfile defines five virtual machines:

- `ubuntu22.04`
- `ubuntu24.04`
- `debian-13`
- `popos-22.04`
- `freebsd14`

To run the experiment on each of them do the following from your host:

```
for vmname in 'ubuntu22.04' 'ubuntu24.04' 'debian-13' 'popos-22.04' 'freebsd14'; do
  vagrant up $vmname
  vagrant ssh $vmname -c '/vagrant/build_tools.sh'
  vagrant ssh $vmname -c '/vagrant/build_release.sh'
done
```

This will take some hours to complete.
Once done, the process generated five files per virtual machine:

- `ubuntu2204.host_info` information about the host and the installed tools, created with [`collect_host_info.sh`](./collect_host_info.sh)
- `ubuntu2204_tools.log.gz` compressed build logs from running the tool build in the VM's default environment, see [`build_tools.sh`](./build_tools.sh)
- `ubuntu2204_tools_small_env.log.gz` compressed build logs from running the tool build in a minimal environment (`env -i HOME="$HOME" PATH=/usr/bin:/bin LC_ALL=C`), see [`build_tools.sh`](./build_tools.sh)
- `ubuntu2204_release.log.gz` compressed build logs from running the tool build in the VM's default environment, see [`build_release.sh`](./build_release.sh)
- `ubuntu2204_release_small_env.log.gz` compressed build logs from running the tool build in a minimal environment (`env -i HOME="$HOME" PATH=/usr/bin:/bin LC_ALL=C`), see [`build_release.sh`](./build_release.sh)


## Results


| OS             | Bare Metal        | Bare Metal Min. Env. |
|----------------|-------------------|----------------------|
| ubuntu22.04    | tools ✔ release ✗ | tools ✔ release ✗    |
| ubuntu24.04    | tools   release   | tools   release      |
| debian-13      |                   |                      |
| popos-22.04    | tools   release   | tools   release      |
| popos-24.04    | tools   release   | tools   release      |
| freebsd14      |                   |                      |
| MacOS Sequoia* | tools   release   | tools   release      |

* Note: For MacOS Sequoia, I conducted the experiment twice.
Once in the default `zsh` environment and once again after changing the default shell to `bash` with `chsh -s /bin/bash`.
The results are the same for both cases.


| OS            | VM VirtualBox     | VM VirtualBox Min. Env. |
|---------------|-------------------|-------------------------|
| ubuntu22.04   | tools ✔ release ✔ | tools ✔ release ✔       |
| ubuntu24.04   | tools   release   | tools   release         |
| debian-13     | tools   release   | tools   release         |
| popos-22.04   | tools   release   | tools   release         |
| freebsd14     | tools   release   | tools   release         |



| OS            | VM Cloud | VM Cloud Min Env |
|---------------|
| ubuntu22.04   |
| ubuntu24.04   |
| debian-13     |
| popos-22.04   |
| freebsd14     |
| VM VirtualBox | VM VirtualBox Min Env | VM Cloud | VM Cloud Min Env |
|               |                       |          |                  |



## Descriptions of my problem and what I did about it

### My First Problem Description on <netbsd-users@netbsd.org>

https://marc.info/?l=netbsd-users&m=179362846988406&w=2




1. I checkout the source code of the NetBSD 11 branch from the Git repository mirror on GitHub:
   `git clone --depth 1 https://github.com/NetBSD/src.git -b netbsd-11 netbsd-11-src`
2. I build the tools
   `./build.sh -U -u -j12 -m amd64 -a x86_64 -O ./obj tools`
   Building the tools works. No errors are reported.
3. I try to build a release with the following command:
   `./build.sh -U -u -j12 -m amd64 -a x86_64 -O ./obj release`



https://marc.info/?l=netbsd-users&m=179369854366366&w=2
https://marc.info/?l=netbsd-users&m=179380493972564&w=2



## Feedback on my environment

- I tried both with LANG=C and LANG=C.UTF-8
- Yes, the files in src and obj are the same
- sh is /bin dash
- The shell from which I start the process is bash


## Feedback gathered from community

Builds on:

- Ubuntu 26.04.1 LTS (RVP <rvp@SDF.ORG>, Wed, 04 Nov 2026 15:43:17 +0000 (11/04/2026 04:43:17 PM))
- Ubuntu 26.04.1 completed successfully (RVP <rvp@SDF.ORG>, Thu, 05 Nov 2026 08:01:26 +0000 (11/05/2026 09:01:26 AM))
- Pop!_OS 22.04 (RVP <rvp@SDF.ORG>, Thu, 05 Nov 2026 08:01:26 +0000 (11/05/2026 09:01:26 AM))
- Debian Trixie 13.7 (Ramiro Aceves <ea1abz@gmail.com>, Wed, 04 Nov 2026 19:27:55 +0100)


## A Systematic Experiment

I want to test the same on multiple virtual machines in VirtualBox.
There should be the following operating systems:

- Pop_OS! 22.04
- Pop_OS! 24.04
- Ubuntu 22.04
- Ubuntu 24.04
- Ubuntu 26.04
- FreeBSD 14-RELEASE
- Debian Trixie 13.7

It should work the following way:

- Give each VM in Vagrant 8cores and 8GB of RAM
- Share the host directory with the VM (in Vagrantfile) bidirectionally, so that later generated log files end up on the host
- On the host, checkout the source code of the NetBSD 11 branch from the Git repository mirror on GitHub:
  `git clone --depth 1 https://github.com/NetBSD/src.git -b netbsd-11 netbsd-11-src`
  - For reproducibility, clone only a precise version `git clone --depth 1 --revision 4198f5370c187384b1de46b9b0fcd04462a420e0 https://github.com/NetBSD/src.git`
- When bringing up the VM with vagrant up, build the tools `./build.sh -U -u -j$(lscpu | grep "^CPU(s):" | awk '{print $2}') -m amd64 -a x86_64 -O $HOME/obj tools`
- Check that building the tools works and no errors are reported.
- Then, build a release with the following command:
   `./build.sh -U -u -j12 -m amd64 -a x86_64 -O ./obj release`


<!-- Do the same with Docker -->

