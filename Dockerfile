FROM nvidia/cuda:10.1-devel-ubuntu16.04

# that link is required. otherwise cannot find lcudart library when we run catkin_make
RUN ln -s /usr/local/cuda/lib64/libcudart.so /usr/lib/libcudart.so

# setup keys
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654

# setup sources.list
RUN echo "deb http://packages.ros.org/ros/ubuntu xenial main" > /etc/apt/sources.list.d/ros1-latest.list

# install bootstrap tools
RUN apt-get update && apt-get install --no-install-recommends -y \
    python-rosdep \
    python-rosinstall \
    python-vcstools \
    && rm -rf /var/lib/apt/lists/*

# setup environment
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

# bootstrap rosdep
RUN rosdep init \
    && rosdep update

# install ros packages
ENV ROS_DISTRO kinetic
RUN apt-get update && apt-get install -y \
    ros-kinetic-ros-core=1.3.2-0* \
    && rm -rf /var/lib/apt/lists/*


RUN apt-get update && \
 apt-get install -y wget vim unzip libcanberra-gtk-module libcanberra-gtk3-module libx11-dev ros-kinetic-opencv3 ros-kinetic-actionlib ros-kinetic-image-transport \
 && rm -rf /var/lib/apt/lists/*


RUN cd ~ && mkdir -p ~/catkin_ws/src && \
 cd ~/catkin_ws/src && \
 git clone --recursive https://github.com/wntun/darknet_ros.git && \
 git clone https://github.com/ros-perception/vision_opencv.git
RUN cd ~/catkin_ws/src/darknet_ros/darknet_ros/yolo_network_config/weights/ && \
 wget "https://konkukackr-my.sharepoint.com/:u:/g/personal/wainwetun_konkuk_ac_kr/EWRFpaqxgvVFtGjqTxMUrZwB_hmb7Of_cGqx81o00CZPuA?e=zO1Mhj&download=1" && \
 cp 'EWRFpaqxgvVFtGjqTxMUrZwB_hmb7Of_cGqx81o00CZPuA?e=zO1Mhj&download=1' soldier-mannequin-yolov3-tiny_best.weights && \
 wget "https://konkukackr-my.sharepoint.com/:u:/g/personal/wainwetun_konkuk_ac_kr/EXkRzMeqAghDrwXc0983sWEBX0U65CZTQ5ThkjTqiLJM0g?e=cg8U3P&download=1" && \
 cp 'EXkRzMeqAghDrwXc0983sWEBX0U65CZTQ5ThkjTqiLJM0g?e=cg8U3P&download=1' soldier-mannequin-yolov3-tiny_last.weights

# setup entrypoint
COPY ./ros_entrypoint.sh /
RUN chmod +x /ros_entrypoint.sh

ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["bash"]
