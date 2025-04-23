# Use a lightweight base image with Python support
FROM ubuntu:20.04

# Set non-interactive mode for apt
ENV DEBIAN_FRONTEND=noninteractive

# Set working directory
WORKDIR /app

# Install dependencies and Python 3.10
RUN apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository ppa:deadsnakes/ppa && \
    apt-get update && \
    apt-get install -y python3.10 python3.10-venv python3-pip git wget && \
    rm -rf /var/lib/apt/lists/*

# Use Python 3.10 as default python and pip
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.10 1 && \
    update-alternatives --install /usr/bin/pip pip /usr/bin/pip3 1

# Copy app files into container
COPY . /app

# Create virtual environment and install Python dependencies
RUN python -m venv venv && \
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
