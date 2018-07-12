# jashinfotec/upycode
Ready to use python3 development with vscode docker container.

## Prequesits
  - [Docker](https://docs.docker.com/install/)

## Use built in container from docker hub.

  ```sh
  cd upycode/
  chmod a+x upycode
  ./upycode --username=username --home-dir=/path/to/home/dir
  ```

## Building Locally
  You can build image locally .
  ```sh
  cd upycode/
  TAG=jashinfotec/upycode
  docker build -t $TAG .
  ```