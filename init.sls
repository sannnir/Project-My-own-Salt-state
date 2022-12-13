#/srv/salt/ownstate/init.sls
mypkgs:
  pkg.installed:
    - pkgs:
      - git
      - micro
