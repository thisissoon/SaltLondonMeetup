include:
  - deps
  - nginx

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
    - require:
      - docker: soon/foo
    - watch:
      - cmd: foo-absent

# Run the container
foo:
  docker.running:
    - container: foo
    - require:
      - docker: foo-container

# Foo Nginx Config
foo-nginx-config:
  file.managed:
    - name: /etc/nginx/conf.d/foo.conf
    - source: salt://foo2.nginx.conf
    - template: jinja
    - watch_in:
      - service: nginx
    - require:
      - docker: foo

# Clean up
cleanup:
  cmd.wait:
    - name: docker rmi $(docker images -q -f dangling=true)
    - watch:
      - cmd: foo-absent
