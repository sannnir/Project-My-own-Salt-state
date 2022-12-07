#/srv/salt/TESTI/init.sls
mypkgs:
  pkg.installed:
    - pkgs:
      - git
      - micro
      - netcat
