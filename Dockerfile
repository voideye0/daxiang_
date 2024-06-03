# Use an official Ubuntu image as the base
FROM ubuntu:20.04

# Install necessary packages
RUN apt-get update && \
    apt-get install -y wget curl tar jq qemu-kvm

# Download necessary files
WORKDIR /app
COPY . .

# Set permissions for the script
RUN chmod +x my_script.sh

# Expose the VNC port
EXPOSE 5900

# Run the script
CMD ["./my_script.sh"]
