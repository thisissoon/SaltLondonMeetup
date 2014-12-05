# Nginx
nginx:
  user:
    - present
  pkg:
    - installed
  file:
    - managed
    - name: /etc/nginx/nginx.conf
    - source: salt://nginx.conf
  service:
    - running
    - reload: True
    - watch:
      - file: nginx
    - require:
      - user: nginx
