# Zenoh C++ Demo

This project demonstrates publishing random vectors using Zenoh C++ on Ubuntu 20.04.

## Prerequisites

- Docker installed on your system

## Quick Start

### Build Docker Image

```bash
make docker-build
```

This will:
1. Pull Ubuntu 20.04 base image
2. Install classic development tools (build-essential, cmake, git, etc.)
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
Publishing random vectors to 'demo/random_vector'...
Press Ctrl+C to stop.
Published #1: [42.345621, 78.123453, 15.678234, 91.234567, 33.456789, 67.890123, 24.567890, 88.123456, 9.876543, 55.432109]
Published #2: [12.345678, 45.678901, 89.012345, 23.456789, 67.890123, 34.567890, 78.901234, 56.789012, 90.123456, 1.234567]
...
```

## Project Structure

```
zenoh_cpp_amd64_20_demo/
├── Dockerfile           # Ubuntu 20.04 with Zenoh C++
├── Makefile            # Build and run commands
├── CMakeLists.txt      # CMake configuration
├── README.md           # This file
└── src/
    └── publish_vector.cpp  # Random vector publisher
```
