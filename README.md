# Jam Hammer

Linux game development framework.   

## Installation 

```bash
git clone https://github.com/jam-hammer/jam-hammer.git
cd jam-hammer/scripts
./1-setup.sh
./2-installLoveToPath.sh # OPTIONAL STEP
``` 

This will clone and compile LÖVE 0.10.0, love.js and sff-love.  
The directory of this repository will be the root directory for all of the Jam Hammer projects.

## Directory structure
TODO

## Create new project
Execute the script `4-newProject.sh` with one argument: the name of the project.  
```bash
cd scripts/
./4-newProject.sh myNewProject
```  
A new project it's simply a copy of the `sff-love` folder with the specified name in the `workspace` directory.    
In the future the script might modify some files in `sff-love`.

## Export to HTML5
Use the `Export HTML5` button in Jam Hammer's UI for your project.

## Update SFF
Use the script `3-updateSff.sh` in the `jam-hammer/scripts` directory.  
All new projects will be generated using the updated version of SFF from that point on.
