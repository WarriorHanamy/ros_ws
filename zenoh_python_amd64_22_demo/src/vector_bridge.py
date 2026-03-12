import json
import random
import time

import zenoh


def main():
    config = zenoh.Config()
    session = zenoh.open(config)

    cpp_key = "demo/random_vector"
    py_key = "demo/python_vector"

    recv_count = 0

    def listener(sample):
        nonlocal recv_count
        recv_count += 1
        print(f"[PY] <- CPP: seq={recv_count}")

    sub = session.declare_subscriber(cpp_key, listener)

    pub = session.declare_publisher(py_key)

    print(f"[PY] Subscribing to '{cpp_key}' from C++ (Ubuntu 20.04)")
    print(f"[PY] Publishing to '{py_key}' (shape: 5x3 matrix)")
    print("[PY] Press Ctrl+C to stop.\n")

    count = 0
    try:
        while True:
            matrix = [[random.uniform(0, 10) for _ in range(3)] for _ in range(5)]
            payload = json.dumps(matrix)
            pub.put(payload)
            print(f"[PY] -> CPP: seq={count + 1}")
            count += 1
            time.sleep(1)
    except KeyboardInterrupt:
        print("\n[PY] Shutting down...")
    finally:
        session.close()


if __name__ == "__main__":
    main()
