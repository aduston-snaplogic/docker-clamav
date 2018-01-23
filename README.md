# ClamAV Docker Demo

This repo is a simple demonstration of how to run clamd with On-Access scanning alongside a web application inside
a container. It contains a sample web application in Flask that allows uploading a file into the container. 

## Building the container 

To build the Docker container check out this repo and run `docker build`:

    git clone https://github.com/aduston-snaplogic/docker-clamav.git
    cd docker-clamav
    docker build -t clamav-demo . 
    
## Running the container 

By default the flask app will bind to port 5000. clamav stores its logs and pid files in the `/clamav`. It is 
recommended to mount that directory to a volume outside the container. 

    docker run -it -d --name clamav-demo -v clamav:/clamav -p 5000:5000 clamav-demo:latest