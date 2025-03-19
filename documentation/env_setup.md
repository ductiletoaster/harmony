
    Date of the guide : March 18, 2025

## Introduction

Below are my personal preferences on setting up my developer enviroment. Most of this is not required to run the services or workflows defined this project. 

## Prerequisites

- Curiosity

##  Step-by-Step Guide

1. **Update Your System:**
    First, make sure your system is up-to-date. 
    Open your terminal and run:

    ```bash
    sudo pacman -Syu
    paru -Syu (or yay -Syu, depends on which AUR package helper you use)
    ```
    
2. **Install prerequisites:**
    You will need some packages to fetch packages
    In the terminal run :
    
    ```bash
    paru -S wget curl
    ```
    
3. **Install Oh My ZSH:**
    My personal preference in shell is ZSH and in my opinion [Oh My ZSH](https://ohmyz.sh/#install) provides the best user experiance for me out of the box.
    
    ```bash
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

    ```
    Customize your installation however you see fit. 


## Follow Guides
- Installing Vscode, docker, etc