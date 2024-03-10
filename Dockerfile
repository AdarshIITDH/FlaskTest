
# Build stage
FROM python:3.9-slim as builder
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Testing stage
FROM builder as tester
WORKDIR /app
COPY . .
RUN python test_app.py

FROM python:3.9-slim
WORKDIR /app
COPY --from=builder /app /app
COPY . .
EXPOSE 5000
CMD ["python", "app.py"]

