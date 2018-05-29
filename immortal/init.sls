{% from "immortal/map.jinja" import conf with context %}

{% if grains['os_family'] == 'Debian' or grains['os_family'] == 'RedHat' %}
packagecloud_immortal:
  cmd.run:
{% if grains['os_family'] == 'Debian' %}
    - name: "curl -s https://packagecloud.io/install/repositories/immortal/immortal/script.deb.sh | bash"
{% elif grains['os_family'] == 'RedHat' %}
    - name: "curl -s https://packagecloud.io/install/repositories/immortal/immortal/script.rpm.sh | bash"
{% endif %}
    - unless: test -f /usr/bin/immortal
{% endif %}

immortal:
  pkg.installed

{{ conf.get('immortaldir_path') }}:
  file.directory:
    - makedirs: True

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
