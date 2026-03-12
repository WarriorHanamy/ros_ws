# Zenoh Python ARM64 Demo (Ubuntu 22.04)

This project demonstrates bidirectional communication using Zenoh Python on Ubuntu 22.04 ARM64.

## Architecture

```
Ubuntu 22.04 ARM64 (C++)               Ubuntu 22.04 ARM64 (Python)
┌─────────────────────┐                ┌──────────────────────┐
│  publish_vector     │ ──demo/random─▶│  vector_bridge       │
│                     │                │                      │
│                     │ ◀─demo/python──│  (5x3 matrix)        │
└─────────────────────┘                └──────────────────────┘
```

## Prerequisites

- Docker installed on your system with ARM64 support

## Quick Start

### Build Docker Image

```bash
make docker-build
```

### Run the Python Bridge

```bash
make docker-run
```

### Open Shell in Container

```bash
make docker-shell
```

### Clean Up

```bash
make docker-clean
```

## Data Formats

- **C++ → Python**: 1D array of 10 doubles `[d1, d2, ..., d10]`
- **Python → C++**: 2D array (5x3 matrix) `[[d11, d12, d13], [d21, d22, d23], ...]`

## Project Structure

```
zenoh_python_arm64_22_demo/
├── Dockerfile           # Ubuntu 22.04 ARM64 with Python and Zenoh
├── Makefile            # Build and run commands
├── README.md           # This file
└── src/
    └── vector_bridge.py  # Python subscriber/publisher
```
