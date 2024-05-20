# Use a slim Python base image
FROM python:3.9-slim

# Set a working directory
WORKDIR /app

# Copy the app.py file
COPY app.py .

# Install Flask (if not already installed in the base image)
RUN pip install Flask

# Expose the port (optional, comment out if not needed)
#EXPOSE 5000

# Define the command to run the app
CMD ["python", "app.py"]
