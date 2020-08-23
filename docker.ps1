docker build -t dummy .
docker run -d --rm --name dummy -v myvolume:/usr/local dummy tail -f /dev/null
docker cp dummy:/usr/local ./build
docker stop dummy
