camera:
  taskset -c 7 ./ros_exec ros2 launch realsense2_camera rs_launch.py \
  camera_namespace:=robot1 camera_name:=D455_1 \
  config_file:=/home/rec/ros2_ws/config/camera_params.yaml

build:
  ./ros_exec build

clean:
  ./ros_exec clean
