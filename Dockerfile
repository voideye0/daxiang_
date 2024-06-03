# Use an official Python runtime as a parent image
FROM python:3.8-slim

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
ADD . /app

# Install any needed packages specified in requirements.txt
RUN pip install -r requirements.txt

# Make port 5900 available to the world outside this container
EXPOSE 5900

# Run app.py when the container launches
CMD ["python", "your_script.py"]
