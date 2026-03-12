# Zenoh Python Demo

This project demonstrates bidirectional communication between C++ (Ubuntu 20.04) and Python (Ubuntu 22.04) using Zenoh.

## Architecture

```
Ubuntu 20.04 (C++)                    Ubuntu 22.04 (Python)
┌─────────────────┐                   ┌──────────────────┐
│  publish_vector │ ──demo/random──▶  │  vector_bridge   │
│                 │                   │                  │
│                 │ ◀─demo/python───  │  (5x3 matrix)    │
└─────────────────┘                   └──────────────────┘
```

## Prerequisites

- Docker installed on your system

## Quick Start

### Build Both Images

```bash
cd ~/ros_ws
make docker-build-zenoh-cpp
make docker-build-zenoh-py
```

### Run Bidirectional Communication

Terminal 1 - Run C++ (Ubuntu 20.04):
```bash
make docker-run-zenoh-cpp
```

Terminal 2 - Run Python (Ubuntu 22.04):
```bash
make docker-run-zenoh-py
```

### Expected Output

C++ Terminal:
```
[CPP] Publishing random vectors to 'demo/random_vector'...
[CPP] Subscribed to 'demo/python_vector' from Python (Ubuntu 22.04)
[CPP] Published #1: [53.20, 52.81, 18.50, ...]
[CPP] Received from Python: [[1.23, 4.56, 7.89], [2.34, ...]]
```

Python Terminal:
```
[PY] Subscribing to 'demo/random_vector' from C++ (Ubuntu 20.04)
[PY] Publishing to 'demo/python_vector' (shape: 5x3 matrix)
[PY] Received from C++: [53.20, 52.81, 18.50, ...]
[PY] Published #1: 5x3 matrix
```

## Data Formats

- **C++ → Python**: 1D array of 10 doubles `[d1, d2, ..., d10]`
- **Python → C++**: 2D array (5x3 matrix) `[[d11, d12, d13], [d21, d22, d23], ...]`

## Project Structure

```
zenoh_python_amd64_22_demo/
├── Dockerfile           # Ubuntu 22.04 with Python and Zenoh
├── Makefile            # Build and run commands
├── README.md           # This file
└── src/
    └── vector_bridge.py  # Python subscriber/publisher
```
