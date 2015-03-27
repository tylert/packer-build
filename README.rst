packer-build
============

::

  python prefetch.py

  packer build -only=vbox template/wheezy.json
  packer build -only=vbox template/wheezy-desktop.json
  packer build -only=vbox template/jessie.json
  packer build -only=vbox template/jessie-desktop.json

  packer build -only=vbox template/trusty.json
  packer build -only=vbox template/trusty-desktop.json
  packer build -only=vbox template/vivid.json
  packer build -only=vbox template/vivid-desktop.json


https://www.debian.org/releases/stable/amd64/
https://help.ubuntu.com/lts/installation-guide/amd64/index.html

http://askubuntu.com/questions/423946/unattended-installation-xubuntu
https://wiki.ubuntu.com/UbiquityAutomation

http://www.scalehorizontally.com/2013/02/24/introduction-to-cloud-init/
http://thornelabs.net/2014/04/07/create-a-kvm-based-debian-7-openstack-cloud-image.html
