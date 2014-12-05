include:
  - deps

# Pull the foo image
soon/foo:
  docker.pulled:
    - tag: latest
    - force: True
    - require:
      - pip: docker-py
      - service: lxc-docker

# Remove the foo container (stop and killed) if the image has changed
foo-absent:
  cmd.wait:
    - name: docker rm -f foo
    - onlyif: docker inspect foo
    - watch:
      - docker: soon/foo

# Create a container
foo-container:
  docker.installed:
    - name: foo
    - image: soon/foo
    - ports:
      - '5000/tcp'
    - require:
      - docker: soon/foo
    - watch:
      - cmd: foo-absent

# Run the container
foo:
  docker.running:
    - container: foo
    - port_bindings:
        "5000/tcp":
            HostIp: ""
            HostPort: "5000"
    - require:
      - docker: foo-container
