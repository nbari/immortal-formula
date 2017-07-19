{% from "immortal/map.jinja" import conf with context %}

fetch_immortal:
{% if grains['os_family'] == 'FreeBSD' %}
  pkg.installed:
    - name: immortal
{% elif grains['os_family'] == 'Debian' %}
  pkg.installed:
    - sources:
      - immortal: {{ conf.source }}
{% endif %}

{{ conf.get('sv-dir') }}/immortal:
  file.directory:
    - makedirs: True

immortaldir:
  service:
    - running
    - provider: runit
    - watch:
      - file: immortal
  file.managed:
    - name: {{ conf.get('etc-path', '/usr/local/etc') }}/immortal.yml
    - template: jinja
    - makedirs: True
    - source: salt://immortal/files/{{ pillar.get('immortal_conf', 'generic') }}.yml

{{ conf.get('SVDIR', '/service') }}/immortal:
  file.symlink:
    - target: {{ conf.get('sv-dir') }}
