# ClamAV Docker Demo

This repo is a simple demonstration of how to run clamd with On-Access scanning alongside a web application inside
a container. It contains a sample web application in Flask that allows uploading a file into the container. 

The [entrypoint.sh](entrypoint.sh) script initiates the clamav and freshclam services along with the flask  demo web app. 
It is based on this [example](https://docs.docker.com/engine/admin/multi-service_container/) from the official Docker 
documentation.

## Building the container 

To build the Docker container check out this repo and run `docker build`:

    git clone https://github.com/aduston-snaplogic/docker-clamav.git
    cd docker-clamav
    docker build -t clamav-demo . 
    
## Running the container 

By default the flask app will bind to port 5000. clamav and freshclam will store logs and pid files in `/clamav` 

The directory containing the `scan.conf` and `freshclam.conf` config files should be mounted to the container at
`/clamav/etc`

In order for ClamAV to run with on-access scanning enabled it needs to be run as `root`. However, it's not sufficient to
simply run the clamd process as the root user inside the container. The user must have the sys_admin capability in order
for clamav to initiate fanotify. This requires passing the `--cap-add SYS_ADMIN` flag to `docker run`. This is
equivalent to running the container with the `--privileged` option (in fact either option will work). 

To start the demo container use the following command:

    docker run -it -d --name clamav-demo -v /path/to/config/dir:/clamav/etc -p 5000:5000 --cap-add SYS_ADMIN clamav-demo:latest