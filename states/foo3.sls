
{% set no_containers = 4 %}

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
{% for x in range(1, no_containers + 1) %}

foo-{{ x }}-absent:
  cmd.wait:
    - name: docker rm -f foo-{{ x }}
    - onlyif: docker inspect foo-{{ x }}
    - watch:
      - docker: soon/foo
    - watch_in:
      - cmd: cleanup

foo-{{ x }}-container:
  docker.installed:
    - name: foo-{{ x }}
    - image: soon/foo
    - require:
      - docker: soon/foo
    - watch:
      - cmd: foo-{{ x }}-absent

foo-{{ x }}:
  docker.running:
    - container: foo-{{ x }}
    - require:
      - docker: foo-{{ x }}-container
    - require_in:
      - file: foo-nginx-config

{% endfor %}

# Foo Nginx Config
foo-nginx-config:
  file.managed:
    - name: /etc/nginx/conf.d/foo.conf
    - source: salt://foo3.nginx.conf
    - template: jinja
    - context:
      no_containers: {{ no_containers }}
    - watch_in:
      - service: nginx

# Clean up
cleanup:
  cmd.wait:
    - name: docker rmi $(docker images -q -f dangling=true)
