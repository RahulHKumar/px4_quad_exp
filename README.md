# px4_quad_exp
Environmental Setup for Quadrotors Using PX4, ROS2 Humble, NvBlox, and VICON MoCap

## Hardware and Basic Steps

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
   - After completing the flight controller setup, proceed to the Orin setup.
   - The following issues were encountered and solved:
     1. The SDK manager does not detect the board. In this case, you need to force the Orin into recovery mode. For the Orin carrier board A603, recovery mode can be initiated by shorting 3 and 4 in W7.
     2. The SDK componenets do not get installed directly on the A603 board. First, flash only the Jetson Linux using Jetpack 6.0
     3. It is possible that the after the above step, USB A drivers do not work. Use a micro USB to USB A convereter (as you are not currently connecting the Orin to host computer) and connect a keyboard/mouse. Change the username and hostname as per documentation.
     4. The wifi drivers are not available by default. So connect to internet through ethernet, and install the driver
        ```bash
        sudo apt install iwlwifi-modules
        ```
     5. Next, manually set up the IP address to 192.168.x.x (just not 55 which is the default one), and proceed.
     6. SSH was enabled by default. Run the following commands:
        ```bash
        sudo apt-get update
        sudo apt-get install openssh-server
        sudo ufw allow 22
        ```
          Check if the above commands worked by doing:
          ```bash
          ssh ubuntu@192.168.x.x
          ```
     7. Now, connect the Orin to an host computer with SDK manager again using an ethernet cable (Note that the board will not be discovered. Ignore that)
     8. Proceed to install Jetson Runtime components and Jetson SDK components for Jetpack 6.0 using the new IP, 192.168.x.x (IMPORTANT: Do not install Jetson Linux again)
     9. If USB A is not working, follow the following link: https://wiki.seeedstudio.com/reComputer_A603_Flash_System/ to redo the whole board setup (steps 1-6) and then do step 7 after setting up static IP.
    
3. **Environment Setup**
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
