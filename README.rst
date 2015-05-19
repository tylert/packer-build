packer-build
============

These Packer templates may be used to build fresh virtual machines.  The
provided preseed and kickstart files may also be used to build fresh real
machines on bare metal as well.


Prefetching ISO Files
---------------------

Under normal circumstances, Packer can fetch its own ISO files just fine.
However, Packer likes to rename all ISOs that it downloads.  If you wish to
avoid this behaviour, simply create symlinks in the packer_cache directory that
have the SHA256 hash of the original URL referenced in the Packer templates.

Do this before "packer build" for each planned target using the 'prefetch'
script:

::

    $ ./prefetch.py vbox/guest-additions.list
    $ ./prefetch.py debian/jessie/multiarch-netinst.list


Using Packer Templates
----------------------

::

    $ packer build -only=vbox debian/jessie/cinnamon-crypt-efi.json
    $ packer build -only=qemu debian/wheezy/xfce-crypt.json
    $ packer build -only=vmwf ubuntu/trusty/base-amd64.json

To verify your templates, force them to be re-sorted and/or to upgrade your
templates whenever the version of Packer changes:

::

    $ packer fix ubuntu/trusty/base-amd64.json > temporary.json
    $ mv temporary.json ubuntu/trusty/base-amd64.json


Using Vagrant Box Files
-----------------------

Only the VirtualBox builder is used to create Vagrant box files.  This is
intentional as, currently, the Vagrant VMware plugin requires a paid license in
order to use it.  Beware that this license expires frequently as new versions
of VMware and/or Vagrant get released.

::

    $ packer build -only=vbox ubuntu/trusty/base-amd64.json
    $ vagrant init build/2015-05-08-18-10/trusty.box
    $ vagrant up
    $ vagrant ssh
    ...
    $ vagrant destroy


Making Bootable USB Drives
--------------------------

Be sure to use the Packer QEMU "kvm" builder when trying to create bootable USB
images.  This allows the use of the "raw" block device format which is ideal
for writing directly to USB drives.  Alternately, you may use "qemu-img
convert" to convert an exiting image in another format to raw mode.

::

    $ packer build -only=qemu debian/jessie/base-amd64.json
    $ dd if=build/2015-05-10-20-55/jessie.img of=/dev/sdb bs=4M
    $ grub-install /dev/sdb

... or, if you just want to "boot" it...

::

    $ qemu-system-x86_64 build/2015-05-10-20-55/jessie.img


Overriding Local ISO Cache Location
-----------------------------------

You may override the default directory used instead of 'packer_cache' by
specifying it with the environment variable 'PACKER_CACHE_DIR':

::

    $ PACKER_CACHE_DIR=/tmp ./prefetch.py debian/jessie/multiarch-netinst.list
    $ PACKER_CACHE_DIR=/tmp packer build -only=vbox debian/jessie/base.json


Serving Local Files via HTTP
----------------------------

::

    $ cd packer_cache
    $ ../sow.py


Install Tools
-------------

* https://packer.io/docs
* https://docs.vagrantup.com/v2/


Preseed Documentation
---------------------

* https://www.debian.org/releases/stable/amd64/
* https://help.ubuntu.com/lts/installation-guide/amd64/index.html


Offical ISO Files
-----------------

* http://cdimage.debian.org/cdimage
* http://releases.ubuntu.com


Other
-----

* http://www.preining.info/blog/2014/05/usb-stick-tails-systemrescuecd/

* http://www.scalehorizontally.com/2013/02/24/introduction-to-cloud-init/
* http://thornelabs.net/2014/04/07/create-a-kvm-based-debian-7-openstack-cloud-image.html

* http://blog.codeship.com/packer-ansible/
* https://servercheck.in/blog/server-vm-images-ansible-and-packer

* http://ariya.ofilabs.com/2013/11/using-packer-to-create-vagrant-boxes.html
* http://blog.codeship.io/2013/11/07/building-vagrant-machines-with-packer.html
* https://groups.google.com/forum/#!msg/packer-tool/4lB4OqhILF8/NPoMYeew0sEJ
* http://pretengineer.com/post/packer-vagrant-infra/

* https://github.com/jpadilla/juicebox
* https://github.com/boxcutter/ubuntu


Why did you use the Ubuntu Server installer to create desktop systems?
----------------------------------------------------------------------

* http://askubuntu.com/questions/467804/preseeding-does-not-work-properly-in-ubuntu-14-04
* https://wiki.ubuntu.com/UbiquityAutomation


Distro Release Names
--------------------

Debian
^^^^^^

* Buster (10.x) supported until 20??-??
* Stretch (9.x) supported until 20??-??
* Jessie (8.x) supported until 20??-??
* Wheezy (7.x) supported until 20??-??
* Squeeze (6.x) supported until 2016-02

Ubuntu
^^^^^^

* Wily (15.10) supported until 2016-07
* Vivid (15.04) supported until 2016-01
* Utopic (14.10) supported until 2015-07
* Trusty (14.04) supported until 2019-04
* Precise (12.04) supported until 2017-04-26

Fedora
^^^^^^

CentOS
^^^^^^

* 7.x supported until 2024-06-30
* 6.x supported until 2020-11-30
* 5.x supported until 2017-03-31
