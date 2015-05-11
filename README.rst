packer-build
============


Release Names
-------------

* Debian:  Wheezy (7.x), Jessie (8.x)
* Ubuntu:  Precise (12.04), Trusty (14.04), Utopic (14.10), Vivid (15.04)


Fetching ISO Files
------------------

Under normal circumstances, packer can fetch its own ISO files just fine.
However, Packer likes to rename all ISOs that it downloads.  If you wish to
avoid this behaviour, simply create symlinks in the packer_cache directory that
have the SHA256 hash of the original URL referenced in the Packer templates.

::

    ./prefetch.py vbox/guest-additions.list
    ./prefetch.py debian/jessie/multiarch-netinst.list


Using Packer Templates
----------------------

::

    packer build -only=vbox debian/jessie/cinnamon-crypt-efi.json
    packer build -only=qemu debian/wheezy/xfce-crypt.json
    packer build -only=vmwf ubuntu/trusty/base.json

Only the VirtualBox builder is used to create Vagrant box files.  This is
intentional as, currently, the Vagrant VMware plugin requires a paid license in
order to use it.  Beware that this license expires frequently as new versions
of VMware and/or Vagrant get released.


Using Vagrant Box Files
-----------------------

::

    packer build -only=vbox ubuntu/trusty/base.json
    vagrant init build/2015-05-08-18-10/trusty.box
    vagrant up
    vagrant ssh
    vagrant destroy


Making Bootable USB Drives
--------------------------

Be sure to use the Qemu "kvm" builder when trying to create bootable USB
images.  This allows the use of the "raw" block device format which is ideal
for writing directly to USB drives.  Alternately, you may use "qemu-img
convert" to convert an exiting image in another format to raw mode.

::

    packer build -only=qemu debian/jessie/base.json
    qemu build/2015-05-10-20-55/jessie.img
    dd of=build/2015-05-10-20-55/jessie.img of=/dev/sdb bs=4M
    grub-install /dev/sdb


Install Tools
-------------

https://packer.io/docs
https://docs.vagrantup.com/v2/


Preseed Documentation
---------------------

https://www.debian.org/releases/stable/amd64/
https://help.ubuntu.com/lts/installation-guide/amd64/index.html


Offical ISO Files
-----------------

http://cdimage.debian.org/cdimage
http://releases.ubuntu.com


Other
-----

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
