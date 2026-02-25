# ROS2 RealSense Workspace

This workspace contains the Intel RealSense ROS2 packages for working with RealSense cameras in ROS2 Humble.

## Prerequisites

- ROS2 Humble
- Intel RealSense camera (D400 series)

## Build

Use the provided `ros_exec` script to build:

```bash
./ros_exec build
```

To clean build artifacts:

```bash
./ros_exec clean
```

## Usage

### Start the Camera Node

**With ros2 run:**

```bash
ros2 run realsense2_camera realsense2_camera_node
```

With parameters (e.g., enable temporal and spatial filters):

```bash
ros2 run realsense2_camera realsense2_camera_node --ros-args \
  -p enable_color:=false \
  -p spatial_filter.enable:=true \
  -p temporal_filter.enable:=true
```

**With ros2 launch:**

```bash
ros2 launch realsense2_camera rs_launch.py
```

With parameters:

```bash
ros2 launch realsense2_camera rs_launch.py \
  depth_module.depth_profile:=1280x720x30 \
  pointcloud.enable:=true
```

### Camera Name and Namespace

Set camera namespace and name to distinguish between cameras and platforms.

**Example with ros2 launch:**

```bash
ros2 launch realsense2_camera rs_launch.py \
  camera_namespace:=robot1 \
  camera_name:=D455_1
```

**Example with ros2 run:**

```bash
ros2 run realsense2_camera realsense2_camera_node \
  --ros-args \
  -r __node:=D455_1 \
  -r __ns:=/robot1
```

### Result Topics

After launching with `camera_namespace:=robot1 camera_name:=D455_1`:

**Nodes:**
```
/robot1/D455_1
```

**Topics:**
```
/robot1/D455_1/color/camera_info
/robot1/D455_1/color/image_raw
/robot1/D455_1/color/metadata
/robot1/D455_1/depth/camera_info
/robot1/D455_1/depth/image_rect_raw
/robot1/D455_1/depth/metadata
/robot1/D455_1/extrinsics/depth_to_color
/robot1/D455_1/extrinsics/depth_to_depth
```

**Services:**
```
/robot1/D455_1/calib_config_read
/robot1/D455_1/calib_config_write
/robot1/D455_1/device_info
/robot1/D455_1/hw_reset
```

## Script

The `ros_exec` script automatically:
- Uses system Python
- Sources ROS environment if `install/setup.bash` exists
- Supports `build`, `clean`, and custom commands

## Submodules

- [realsense-ros](https://github.com/realsenseai/realsense-ros.git) - Intel RealSense ROS2 wrapper
