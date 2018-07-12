# upycode
Ready to use python3 development docker container.

## Prequesits
  - Docker

## Use built in container from docker hub.

  ```sh
  cd upycode/
  chmod a+x upycode
  ./upycode --username=username --home-dir=/path/to/home/dir
  ```

## build
  You can build image localy .
  ```sh
  cd upycode/
  TAG=jashinfotec/upycode
  docker build -t $TAG .
  ```