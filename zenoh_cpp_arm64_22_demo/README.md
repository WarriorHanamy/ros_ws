# Zenoh C++ ARM64 Demo (Ubuntu 22.04)

This project demonstrates publishing random vectors using Zenoh C++ on Ubuntu 22.04 ARM64.

## Prerequisites

- Docker installed on your system with ARM64 support

## Quick Start

### Build Docker Image

```bash
make docker-build
```

This will:
1. Pull Ubuntu 22.04 base image
2. Install development tools (build-essential, cmake, git, etc.)
3. Install Rust toolchain
4. Build and install zenoh-c (1.7.2)
5. Build and install zenoh-cpp (1.7.2)
6. Build the random vector publisher

### Run the Publisher

```bash
make docker-run
```

The publisher will:
- Connect to Zenoh (peer-to-peer mode by default)
- Publish a random vector of 10 doubles every second
- Print each published vector to stdout

### Open Shell in Container

```bash
make docker-shell
```

### Clean Up

```bash
make docker-clean
```

## Local Build (Optional)

If you have zenoh-c and zenoh-cpp already installed:

```bash
make build
make run
```

## Output Example

```
[CPP] Publishing random vectors to 'demo/random_vector'...
[CPP] Subscribed to 'demo/python_vector' from Python (Ubuntu 22.04 ARM64)
[CPP] Press Ctrl+C to stop.

[CPP] -> PY: seq=1
[CPP] <- PY: seq=1
[CPP] -> PY: seq=2
...
```

## Project Structure

```
zenoh_cpp_arm64_22_demo/
├── Dockerfile           # Ubuntu 22.04 ARM64 with Zenoh C++
├── Makefile            # Build and run commands
├── CMakeLists.txt      # CMake configuration
├── README.md           # This file
└── src/
    └── publish_vector.cpp  # Random vector publisher
```
