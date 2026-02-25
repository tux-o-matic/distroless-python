# Distroless container image for Python
Build Python web app on [distroless images](https://quay.io/repository/hummingbird/python).
Between virtual environment, pip and limited user permissions, getting a Python web app to run properly in a container requires more than just having Python in your base image.

Source 2 image scripts are coming from the [sclorg repository](https://github.com/sclorg/s2i-python-container/tree/master)

## Usage

## Building the base image
The Containerfile in this repository will take a distroless Python image and add s2i scripts needed to deal with virtual environments and running Python web applications in a container as a regular user.

Build the base image:
```shell
podman build -t distroless-python:3.14 .
```

## Building your application
Reference the base image built in the previous step in the `FROM` command then add your code from the `source` directory to the temporary folder where the s2i script expects to find your code.
Then use the s2i `assemble` script as root to let pip install your dependencies before switching back to a regular user.
```shell
FROM localhost/distroless-python:3.14

ADD source /tmp/src/

USER 0

RUN $STI_SCRIPTS_PATH/assemble

USER 1001

CMD $STI_SCRIPTS_PATH/run
```
