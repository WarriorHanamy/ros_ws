#include <iostream>
#include <vector>
#include <random>
#include <chrono>
#include <thread>
#include "zenoh.hxx"

int main() {
    zenoh::Config config = zenoh::Config::create_default();
    zenoh::Session session(std::move(config));

    zenoh::KeyExpr keyexpr("demo/random_vector");
    zenoh::Publisher publisher = session.declare_publisher(keyexpr);

    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_real_distribution<double> dis(0.0, 100.0);

    std::cout << "Publishing random vectors to 'demo/random_vector'..." << std::endl;
    std::cout << "Press Ctrl+C to stop." << std::endl;

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

        zenoh::Bytes data(payload);
        publisher.put(std::move(data));

        std::cout << "Published #" << ++count << ": " << payload << std::endl;

        std::this_thread::sleep_for(std::chrono::seconds(1));
    }

    return 0;
}
