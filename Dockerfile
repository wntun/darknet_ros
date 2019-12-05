FROM osrf/ros:melodic-desktop

RUN apt-get update && \
 apt-get install -y wget vim
RUN cd ~ && mkdir -p ~/catkin_ws/src && \
 cd ~/catkin_ws/src && \
 git clone --recursive https://github.com/wntun/darknet_ros.git 
RUN cd ~/catkin_ws/src/darknet_ros/darknet_ros/yolo_network_config/weights/ && \
 wget "https://konkukackr-my.sharepoint.com/:u:/g/personal/wainwetun_konkuk_ac_kr/ERsAAcsSMztNkSxkYuo14dIBBQzJfCyamhjKZULyrPdXQQ?e=rmPdn6&download=1" && \
 cp 'ERsAAcsSMztNkSxkYuo14dIBBQzJfCyamhjKZULyrPdXQQ?e=rmPdn6&download=1' soldier-mannequin-yolov3-tiny_best.weights
