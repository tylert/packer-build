packer-build
============

::

    ./prefetch.py vbox/guest-additions.list
    ./prefetch.py jessie/debian-multiarch-netinst.list
    ./prefetch.py wheezy/debian-multiarch-netinst.list
    ./prefetch.py trusty/ubuntu-server-amd64-mac.list

    packer build -only=vbox jessie/cinnamon-crypt-efi.json
    packer build -only=qemu wheezy/xfce-crypt.json
    packer build -only=vmwf trusty/base.json


http://cdimage.debian.org/cdimage
http://cdimage.ubuntu.com

https://www.debian.org/releases/stable/amd64/
https://help.ubuntu.com/lts/installation-guide/amd64/index.html

http://www.preining.info/blog/2014/05/usb-stick-tails-systemrescuecd/

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

https://github.com/jpadilla/juicebox
https://github.com/boxcutter/ubuntu


Why did you use the Ubuntu Server installer to create desktop systems?
----------------------------------------------------------------------

http://askubuntu.com/questions/467804/preseeding-does-not-work-properly-in-ubuntu-14-04
https://wiki.ubuntu.com/UbiquityAutomation
