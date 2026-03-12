FROM python:3.11-slim AS builder

RUN pip install --no-cache-dir eclipse-zenoh

FROM python:3.11-slim

COPY --from=builder /usr/local/lib/python3.11/site-packages /usr/local/lib/python3.11/site-packages

WORKDIR /app

COPY src/ /app/src/

CMD ["python3", "src/vector_bridge.py"]
