# PX4 Quad Experiments

Environmental Setup for Quadrotors Using PX4, ROS2 Humble, NvBlox, and VICON MoCap

## Table of Contents
- [Hardware Setup](#hardware-setup)
- [Environment Setup](#environment-setup)
- [Algorithms](#algorithms)
- [Examples using Isaac Lab](#examples-using-isaac-lab)
  
## Hardware Setup

1. **Fork Repository**
   - Fork [PX4-Autopilot-Quad](https://github.com/RahulHKumar/PX4-Autopilot-Quad) into your personal repository for future development.

2. **Build the Drone**
   - Follow the guide at [DASC Lab Vision Drone Guide](https://dasc-lab.github.io/robot-framework/vision_drone/vision_drone_guide.html).
   - Key Notes:
     1. Set `MAV_SYS_ID` to a unique value different from other drones (e.g., `MAV_SYS_ID=3`).
     2. Set `XRCE_DDS_DOM_ID` to match `ROS_DOMAIN_ID` (e.g., `ROS_DOMAIN_ID=3`).
     3. **QUAD_M:**
        - Update this parameter based on the mass of your quadrotor.
     4. **Check for Unavailable Properties** (Consult with Kaleb if needed):
        - `COM_RCL_EXCEPT`
        - `EKF2_HGT_MODE`
     5. **Set Quadrotor Position Parameters:**
        - `QUAD_ROT1_POSX`: `0.064`
        - `QUAD_ROT1_POSY`: `0.085`
        - `QUAD_ROT2_POSX`: `-0.076`
        - `QUAD_ROT2_POSY`: `-0.085`
        - `QUAD_ROT3_POSX`: `0.064`
        - `QUAD_ROT3_POSY`: `-0.085`
        - `QUAD_ROT4_POSX`: `-0.076`
        - `QUAD_ROT4_POSY`: `0.085`

3. **Orin Setup**

     1. Follow the [link](https://wiki.seeedstudio.com/reComputer_A603_Flash_System/) to install Jetson Linux for Jetpack 6.2. This method works best to ensure that all the USB ans wifi drivers are working.
     2. The above method installs only Jetson Linux, not any SDK or Runtime Components. Use SDK manager to cleanly install the other neccessary components
     1. The SDK manager does not detect the board. In this case, you need to force the Orin into recovery mode. For the Orin carrier board A603, recovery mode can be initiated by shorting 3 and 4 in W7.
     3. Manually set up the IP address to 192.168.x.x (just not 55 which is the default one), and proceed.
     4. If SSH was disabled by default. Run the following commands:
        ```bash
        sudo apt-get update
        sudo apt-get install openssh-server
        sudo ufw allow 22
        ```
          Check if the above commands worked by doing:
          ```bash
          ssh ubuntu@192.168.x.x
          ```
     5. Now, connect the Orin to an host computer with SDK manager again using an ethernet cable (Note that the board will not be discovered. Ignore that)
     6. Proceed to install Jetson Runtime components and Jetson SDK components for Jetpack 6.2 using the new IP, 192.168.x.x (IMPORTANT: Do not install Jetson Linux again)
     7. Connect the Orin to PX4 using CSI cable. Run the followig command to check if ```USB0``` and ```USB1``` are visible:
        ```
        ls /dev/tty*
        ```
        NOTE: Check the directionality of the connections. The blue part should be visible from the bottom of the drone, as shown in the image below:
        <p align="center">
           <img src="https://github.com/RahulHKumar/px4_quad_exp/blob/main/media/ttyusb_cable.jpg" alt="Title Image" width="500"/>
         </p>
     9. Connect vicon markers, about 6-8 around the drone. Use double tape and ensure it is firmly stuck to the bosy of the quad. Turn and vibrate to check if they stay firm.
         <p align="center">
           <img src="https://github.com/RahulHKumar/px4_quad_exp/blob/main/media/vicon_markers.jpg" alt="Title Image" width="500"/>
         </p>


## Environment Setup

**Environment Setup**
- After completing the Orin setup, run the following command and reboot:
  ```bash
  sudo usermod -aG docker $USER
  ```
- Then follow the 5 links given below in the right order:
  1. https://nvidia-isaac-ros.github.io/getting_started/dev_env_setup.html
  2. https://nvidia-isaac-ros.github.io/getting_started/hardware_setup/compute/jetson_vpi.html
  3. https://nvidia-isaac-ros.github.io/getting_started/hardware_setup/sensors/realsense_setup.html
  4. https://nvidia-isaac-ros.github.io/repositories_and_packages/isaac_ros_nvblox/isaac_ros_nvblox/index.html#set-up-development-environment
  5. https://nvidia-isaac-ros.github.io/concepts/scene_reconstruction/nvblox/tutorials/tutorial_realsense.html
- Follow [step 8 and 9](https://github.com/tkkim-robot/px4_ugv_exp/tree/main) from our PX4 UGV experiment documentation to modify the ```run_dev.sh``` and ```workspace-entrypoint.sh``` files amongst others in order to enable custom developement, so that we can add our dasc repositories to the docker.
- Follow the [DASC Lab Vision Drone Guide](https://dasc-lab.github.io/robot-framework/vision_drone/vision_drone_guide.html) to setup ground station on your favorite laptop
