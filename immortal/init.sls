{% from "immortal/map.jinja" import conf with context %}

immortal:
{% if grains['os_family'] == 'FreeBSD' %}
  pkg.installed
{% elif grains['os_family'] == 'Debian' %}
  pkg.installed:
    - sources:
      - immortal: {{ conf.source }}
{% endif %}

{{ conf.get('immortaldir_path') }}:
  file.directory:
    - makedirs: True

{% if grains['os_family'] == 'Debian' %}
/etc/systemd/system/immortaldir.service:
  file.managed:
    - template: jinja
    - source: salt://immortal/files/immortaldir.service
{% endif %}

immortaldir:
{% if grains['os_family'] == 'FreeBSD' %}
  sysrc.managed:
    - name: immortaldir_path
    - value: {{ conf.get('immortaldir_path') }}
{% endif %}
  service.running:
    - enable: True
    - require:
      - pkg: immortal
