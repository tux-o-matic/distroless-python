# distroless-python
Build Python web app on distroless images.
Between pip and web framework specific listener, getting a Python web app to run in a container and as a regular user requires more than just having Python in your base image.

Source 2 image scripts are coming the [sclorg repository](https://github.com/sclorg/s2i-python-container/tree/master)

## Usage

## Building the base image
The Containerfile in this repository will add s2i scripts needed to deal with virtual environments and running Python web applications in container as regular users.

Build this image then use it as a base for your applications.
```shell
podman build -t distroless-python:3.14 .
```

## Building your application
Reference the base image built in the previous step in the `FROM` command then add your code from the `source` directory and use the s2i `assemble` script to let pip install your dependencies.
```shell
FROM localhost/distroless-python:3.14

USER 0

ADD source ${APP_ROOT}

RUN $STI_SCRIPTS_PATH/assemble

USER 1001

CMD $STI_SCRIPTS_PATH/run
```
