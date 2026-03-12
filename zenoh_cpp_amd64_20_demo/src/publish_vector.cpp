#include <iostream>
#include <vector>
#include <random>
#include <chrono>
#include <thread>
#include "zenoh.hxx"

using namespace zenoh;

int main() {
    auto config = Config::create_default();
    auto session = Session::open(std::move(config));

    KeyExpr cpp_keyexpr("demo/random_vector");
    auto publisher = session.declare_publisher(cpp_keyexpr);

    KeyExpr py_keyexpr("demo/python_vector");
    
    int recv_count = 0;
    auto data_handler = [&recv_count](const Sample& sample) {
        std::cout << "[CPP] <- PY: seq=" << ++recv_count << std::endl;
    };

    auto subscriber = session.declare_subscriber(py_keyexpr, data_handler, closures::none);

    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_real_distribution<double> dis(0.0, 100.0);

    std::cout << "[CPP] Publishing random vectors to 'demo/random_vector'..." << std::endl;
    std::cout << "[CPP] Subscribed to 'demo/python_vector' from Python (Ubuntu 22.04)" << std::endl;
    std::cout << "[CPP] Press Ctrl+C to stop.\n" << std::endl;

    int count = 0;
    while (true) {
        std::vector<double> vec;
        vec.reserve(10);
        for (int i = 0; i < 10; ++i) {
            vec.push_back(dis(gen));
        }

        std::string payload = "[";
        for (size_t i = 0; i < vec.size(); ++i) {
            payload += std::to_string(vec[i]);
            if (i < vec.size() - 1) payload += ", ";
        }
        payload += "]";

        publisher.put(Bytes(payload));

        std::cout << "[CPP] -> PY: seq=" << ++count << std::endl;

        std::this_thread::sleep_for(std::chrono::seconds(1));
    }

    return 0;
}
