# Use an official Python runtime as a parent image
FROM python:3.10-slim

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy the dependency file first to leverage Docker layer caching
COPY requirements.txt .

# Install dependencies, including the new prometheus-flask-exporter
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code
# This includes application.py, wsgi.py, and the static/templates folders
COPY . .

# Expose the port the Flask app runs on (inside the container)
EXPOSE 5000

# The command to run the application using Gunicorn
# wsgi:app points to the application object defined in wsgi.py
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "wsgi:app"]
