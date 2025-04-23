# Use the NVIDIA PyTorch base image with CUDA support
FROM nvidia/cuda:11.7.1-cudnn8-runtime-ubuntu20.04

# Set non-interactive mode for apt-get
ENV DEBIAN_FRONTEND=noninteractive

# Set working directory
WORKDIR /app

# Install Python and dependencies
RUN apt-get update && \
    apt-get install -y python3.10 python3-pip python3-venv git wget && \
    rm -rf /var/lib/apt/lists/*

# Copy app files into container
COPY . /app

# Create virtual environment and install Python dependencies
RUN python3 -m venv venv && \
    . venv/bin/activate && \
    pip install --upgrade pip && \
    pip install -r requirements.txt

# Activate venv in every shell
ENV PATH="/app/venv/bin:$PATH"

# Environment variable for Flask
ENV FLASK_ENV=production

# Expose Flask port
EXPOSE 5001

# Run the Flask app
CMD ["python", "app.py"]
