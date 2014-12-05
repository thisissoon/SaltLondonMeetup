# Salt London Meetup - Hosted by SOON_

To run these states all you need is Docker and if you are on OSX or windows you
will also need Boot2Docker. Then follow the build instructions.

Slides from the talk can be found here on [Slide Share](http://www.slideshare.net/SOON_/salt-docker-1)

## Build the Salt Docker Image

```
docker build -t salt .
```

## Run the Docker Image

```
docker run -it --privileged --add-host salt:127.0.0.1 -p 80:80 -p 5000:5000 -v `pwd`/states:/srv/salt/states --name salt salt /bin/bash
```

## Run the Master

```
salt-master -d
```

## Run the States

```
salt-call state.sls foo
salt-call state.sls foo2
salt-call state.sls foo3
```
