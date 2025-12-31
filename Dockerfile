# Use Python3.7
FROM python:3.7

# Copy requirements.txt to the docker image and install packages
COPY requirements.txt /
RUN pip install -r requirements.txt

# Set the WORKDIR to be the folder
WORKDIR /app
COPY . .

# Make entrypoint script executable
RUN chmod +x docker-entrypoint.sh

# Expose port 8080
EXPOSE 8080
ENV PORT 8080

# Use entrypoint script
ENTRYPOINT ["./docker-entrypoint.sh"]
