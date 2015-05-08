packer-build
============

::

    ./prefetch.py vbox/guest-additions.list
    ./prefetch.py debian/jessie/multiarch-netinst.list
    ./prefetch.py debian/wheezy/multiarch-netinst.list
    ./prefetch.py ubuntu/trusty/server-amd64.list
    ./prefetch.py ubuntu/precise/server-i386.list

    packer build -only=vbox debian/jessie/cinnamon-crypt-efi.json
    packer build -only=qemu debian/wheezy/xfce-crypt.json
    packer build -only=vmwf ubuntu/trusty/base.json

    vagrant init build/2015-05-08-18-10/trusty.box
    vagrant up
    vagrant ssh
    vagrant destroy


https://packer.io/docs

http://cdimage.debian.org/cdimage
http://releases.ubuntu.com

https://www.debian.org/releases/stable/amd64/
https://help.ubuntu.com/lts/installation-guide/amd64/index.html

http://www.preining.info/blog/2014/05/usb-stick-tails-systemrescuecd/

http://www.scalehorizontally.com/2013/02/24/introduction-to-cloud-init/
http://thornelabs.net/2014/04/07/create-a-kvm-based-debian-7-openstack-cloud-image.html

http://blog.codeship.com/packer-ansible/
https://servercheck.in/blog/server-vm-images-ansible-and-packer

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
