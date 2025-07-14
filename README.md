# PX4 Quad Experiments

Environmental Setup for Quadrotors Using PX4, ROS2 Humble, NvBlox, and VICON MoCap

## Table of Contents
- [Hardware Setup](#hardware-setup)
- [Environment Setup](#environment-setup)
- [Precautions before flying](#precautions-before-flying)
- [Ground station usage tips](#ground-station-usage-tips)
- [Integration with Safe Control and Safe Exploration](#integration-with-safe-control-and-safe-exploration)
  
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
- Additionally, you may have to add the following line to ```run_dev.sh``` if you encounter any error while first building the container:
  ```
  RUN python3 -m pip install --upgrade \
        "packaging>=24"
  ```
- Follow the [DASC Lab Vision Drone Guide](https://dasc-lab.github.io/robot-framework/vision_drone/vision_drone_guide.html) to setup ground station on your favorite laptop.


## Precautions before flying

After following the above steps correctly, you are ready to fly and perform some prelimnary tests. You can make use of the following tips so that you do not crash the autonomus drone as much as I did :p 
- Make sure all vicon cameras are on and the flight space is calibrated.
- Ensure you are giving goals wrt the right coordinates (z is flipped in both DASC lab spaces)
- Make sure motors are fixed after checking the directionality correctly.
- Ensure the vicon markers and motors both do not move on vibration.
- Recheck all PX4 parameters correctly.
- After turning the system on,move the drone with your hand to check if EKF and Vicon localization match with good speed.
- Make sure cables are not danglong out and might touch motors on spinning.
- Use ground station RViz markers to check if the setpoints are within the flight space bounds.
- First do a in-place takeoff test with very low QUAD_M (eg: 0.1). This should not fly but remain stable in place.
- Repeat the same test with very small z-setpoint and test takeoff. (PS: Never give z-setpoint lower than the current z during takeoff)
- Fly the drone manually using groundstation control before autonmous flight.

## Ground station usage tips

- Clone your own version of groundstation: [rover_groundstation_ros2_jumstart.git](https://git@github.com:dasc-lab/rover_groundstation_ros2_jumpstart.git) and build using instructions on [DASC Lab Vision Drone Guide](https://dasc-lab.github.io/robot-framework/vision_drone/vision_drone_guide.html), in order to be able to do customizations in the future.
- On successflly building the groundstation, follow instructions from [px4_ugv_exp]((https://github.com/tkkim-robot/px4_ugv_exp/tree/main)) to turn on all systems:
  - 1. Turn on the VICON.
    - Turn two VICON computers and one switch on.
    - On system tab, reboot the red cameras 
    - On object tab, de-select "auto enable" and click "track".
    - Press 'alt' and drag markers of interset, and type the name (default: px4_1) and done. 
    - Right click 'px4_1' on object tab, click "save object" and make it "shared". 
  - 2. Turn on the rover with Orin and charged battery, put on markers on the plate (to be asymmetric).
  - 3. Place the indicator to the battery (left sided), and change the beep threshold to 3.70. (11.1v is the lowest voltage to stop, it's charged up to 12.x v.)
  - 4. SSH into the Orin with VSCode.
  - 5. Setup ground station with random laptop.
    - ``` cd hardik/rover_groundstation_ros2_jumpstart```
    - ``` xhost + ```
    - ``` docker compose up -d ```
    - ``` docker exec -it rover_groundstation_ros2_jumpstart-gs-1 bash```
    - ``` (in the docker) ROS_DOMAIN_ID=4 ros2 launch ground_station_launch  gs.launch.py ```

  - 6. Setup Orin with SSH in VSCODE
    - ``` docker start isaac-(...) ```
    - ``` docker exec -it isaac-(...) bash```
    - ``` (in the docker) cd colcon_ws && source install/setup.bash```
    - ``` sudo chmod 777 /dev/ttyUSB1 ```
    - ``` ROS_DOMAIN_ID=7 ros2 launch all_launch px4.launch.py ```
    - Then, the RVIZ in groundstation turns green to "VALID"
- After following the abive instructions, your groundstation view should loom something like the picture below (PS: I am also running the realsense example from NvBlox)
  <p align="center">
    <img src="https://github.com/RahulHKumar/px4_quad_exp/blob/main/media/gnd_station_view.png" alt="Title Image" width="500"/>
  </p>
  Depending on whether you choose Global Frame to be odom or vicon_world you will either see the map or setpoint/current position of drone respectively.
- I would suggest start the flight with ```vicon_world``` fixed frame and switch to ```odom``` or ```map``` after you are confident that the drone is flying in a stable fashion.
- Since the autonomous flying process for the quad is complicated and prone to crashes, I would like to reccomend a terminal structure as folows:
  <p align="center">
    <img src="https://github.com/RahulHKumar/px4_quad_exp/blob/main/media/terminal_structure.png" alt="Title Image" width="500"/>
  </p>
- I liked to keep the one-time run processes lime ```px4.launch.py``` and ```realsense_example.launch.py``` in the terminals below. The latter can be hidden as well as it does not need monitoring after the flight begins.
- I liked keeping the ```publish_u_quad.py``` and either ```publish_tracking_circle.py``` or ```ros_exploration_pub.py``` on the bigger terminals occupying most of the screen, depending on whether I am running safe_control or safe_explorartion scripts. This is due to the fact that the logs on these scripts can indicate very well what the status of the flight is and if anything is going wrong. In a smaller terminal anywhere, run a rosbag record as this will be useful in debugging.

## Integration with Safe Control and Safe Exploration

Simply clone the submodules of ```safe_control``` or ```seamlis``` into the scripts folder in ```dasc_ros_utils``` and add them into the CMakeList according to the file paths, and ```colcon build```. This will ensure seamless integration of any type of safe autonomous control repository into the architecture that runs quadrotor experiments.
