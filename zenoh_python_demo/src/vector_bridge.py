import zenoh
import json
import random
import time


def main():
    config = zenoh.Config()
    session = zenoh.open(config)

    cpp_key = "demo/random_vector"
    py_key = "demo/python_vector"

    def listener(sample):
        try:
            payload = sample.payload.to_string()
            print(f"[PY] Received from C++: {payload}")

            vec = json.loads(payload)
            print(f"[PY] Vector shape: {len(vec)}, values: {vec[:3]}...")
        except Exception as e:
            print(f"[PY] Error parsing: {e}")

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
            print(f"[PY] Published #{count + 1}: 5x3 matrix")
            count += 1
            time.sleep(1)
    except KeyboardInterrupt:
        print("\n[PY] Shutting down...")
    finally:
        session.close()


if __name__ == "__main__":
    main()
