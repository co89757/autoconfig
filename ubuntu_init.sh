#!/bin/sh

## Install dev essential tools 

sudo apt-get update 
echo "....... Start to install build-essentials ...."
sudo apt-get install build-essential 
sudo 
echo "...... Start to install python-related tools ...."
sudo apt-get install python3
sudo apt-get install python-pip 
sudo apt-get install python3-pip 
sudo apt-get install g++

echo '..... install vim .....'
sudo apt-get install vim


