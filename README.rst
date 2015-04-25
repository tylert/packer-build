packer-build
============

::

    ./prefetch.py template/jessie/cinnamon-crypt-efi.list
    ./prefetch.py template/wheezy/xfce-crypt.list
    ./prefetch.py template/trusty/base.list

    packer build -only=vbox template/jessie/cinnamon-crypt-efi.json
    packer build -only=qemu template/wheezy/xfce-crypt.json
    packer build -only=vmwf template/trusty/base.json


https://www.debian.org/releases/stable/amd64/
https://help.ubuntu.com/lts/installation-guide/amd64/index.html

http://www.preining.info/blog/2014/05/usb-stick-tails-systemrescuecd/

http://askubuntu.com/questions/423946/unattended-installation-xubuntu
https://wiki.ubuntu.com/UbiquityAutomation

http://www.scalehorizontally.com/2013/02/24/introduction-to-cloud-init/
http://thornelabs.net/2014/04/07/create-a-kvm-based-debian-7-openstack-cloud-image.html

http://fabbritech.blogspot.ca/2013/08/how-to-install-kvm-qemu-hard-drive.html
http://www.savelono.com/linux/how-to-migrate-a-qemu-kvm-image-to-a-physical-machinepc.html
http://superuser.com/questions/114445/is-it-possible-to-convert-virtual-machines-to-physical-environments

http://blog.codeship.com/packer-ansible/
https://servercheck.in/blog/server-vm-images-ansible-and-packer
https://www.packer.io/docs/provisioners/ansible-local.html

http://ariya.ofilabs.com/2013/11/using-packer-to-create-vagrant-boxes.html
http://blog.codeship.io/2013/11/07/building-vagrant-machines-with-packer.html
https://groups.google.com/forum/#!msg/packer-tool/4lB4OqhILF8/NPoMYeew0sEJ
http://pretengineer.com/post/packer-vagrant-infra/
