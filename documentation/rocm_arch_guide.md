
    Date of the guide : March 18, 2025

## Introduction

In this post, I will provide the solution that worked on my system on how to install Radeon Open Compute (ROCm) on Arch (linux-6.6.7.arch1-1) for RX 6900 XT (Should work on other 6000 series). 
ROCm is an open-source software platform that allows GPU-accelerated computation. 
This tool is a prerequist to use GPU Acceleration on TensorFlow or PyTorch.
In this guide I will use Paru as my AUR package helper, feel free to use any other (https://wiki.archlinux.org/title/AUR_helpers).
I will assume you have a working operating system and know what you do with it (Otherwise Arch will be painfull for you).

> Note AMD does not have an official guide for Arch based distributions. Here are the official [quick start guides](https://rocm.docs.amd.com/projects/install-on-linux/en/latest/install/quick-start.html#) for reference. 

## Prerequisites

- A computer running Arch
- Access to AUR
- A compatible AMD GPU 

##  Step-by-Step Guide

1. **Update Your System:**
    First, make sure your system is up-to-date. 
    Open your terminal and run:

    ```bash
    sudo pacman -Syu
    paru -Syu (or yay -Syu, depends on which AUR package helper you use)
    ```
    
2. **Install prerequisites:**
    You will need some packages to fetch and compile ROCm 
    In the terminal run :
    
    ```bash
    paru -S wget make curl gperftools
    ```
    
3. **Install PyEnv:**
    I choose to install PyEnv to manage my Python version, you can directly install Python if the version you use is compatible with ROCm
    
    ```bash
    curl https://pyenv.run | bash
    ``
    
    Add theses lines to your .bashrc (located in your /home/username folder) : 
    
    ```bash
    vim ~/.bashrc (or nano ~/.bashrc)
    ```
    
    ```bash
    export PYENV_ROOT="$HOME/.pyenv"
    [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init - bash)"
    eval "$(pyenv virtualenv-init -)"
    ```
    
    Now refresh the shell by either closing and reopening your terminal or execute this : 
    
    ```bash
    exec $SHELL
    ```
    
    Now to be sure PyEnv is installed run : 
    
    ```bash
    pyenv
    ```
    
    If the commands list is printed in your terminal, then you managed to installed otherwise go to PyEnv wiki to try fix the install : (https://github.com/pyenv/pyenv/wiki) 

    In addition it is recommended you follow this [Suggested build enviroment](https://github.com/pyenv/pyenv/wiki#suggested-build-environment) to prepare for proper installation of specific python versions. 

    In my particular case I found I needed to modify one the command under Arch Linux to the following:
    ```bash
    sudo pacman -S --needed base-devel openssl xz tk
    ```
    
4. **Install Python:**

    Now that we have PyEnv we can install Python, in this guide, I will use Python 3.13.2 (Lateset version supported at the date I'm writing this guide).

    ```bash
    pyenv install 3.13.2
    ```

    PyEnv have installed the 3.13.2 version, now we need to tell our system to use this version.

    ```bash
    pyenv global 3.13.2
    ```

    To ensure we have the right version execute :

    ```bash
    python --version
    ```

    If the command return 3.13.2 then you have the version you just installed as the version your system will use.

4. **Install ROCm:**

    Now that we have everything setup we can install ROCm, in your terminal run : 

    ```bash
    paru -S rocm-hip-sdk rocm-opencl-sdk
    ```

    You now have ROCm installed, but we need a bit more step to make it work.

5. **Configuring stuff:**

    You will need to add your session to user groups.

    ```bash
    sudo gpasswd -a username render
    sudo gpasswd -a username video
    ```

    Then you will have to edit .bashrc / .zshrc again, add this :

    ```bash
    export ROCM_PATH=/opt/rocm
    export HSA_OVERRIDE_GFX_VERSION=10.3.0
    ```

    If you have a GPU that are from 7XXX series, then you need to change the 10.3.0 value to 11.0.0.
    From there you basically should have a working environnement with ROCm, next steps is try it.
  
6. **Testing ROCm with Tensorflow:**
  
   Now simply install the library with pip.

    ```bash
    pip install --user tensorflow-rocm
    ````
    
    ```bash
    git clone https://github.com/mpeschel10/test-tensorflow-rocm.git
    ```
    
    CD into the folder just cloned.
    
    ```bash
    cd test-tensorflow-rocm
    ```
    
    And run the .py file 
    
    
    ```bash
    python test_tensorflow.py
    ```
    
    If it's running 5 Epochs and printing the time your GPU made to pass the test, congratulations ! You now have a working ROCm environnement !
    For numbers here are my result with a RX 6900XT :
    
    ```bash
    313/313 - 0s - loss: 0.0657 - accuracy: 0.9808 - 249ms/epoch - 795us/step
    Your run took 9.433697 seconds.
    // This stat below are from the author of the test.
    My GPU takes 14 seconds.
    My CPU takes 74 seconds.
    Your mileage may vary.
    ```

    
  