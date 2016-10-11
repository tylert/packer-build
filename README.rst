packer-build
============


What does this do?
~~~~~~~~~~~~~~~~~~

These Packer templates and associated files may be used to build fresh Debian
and Ubuntu virtual machine images for Vagrant, VirtualBox and QEMU.

The resulting image files may be used as bootable systems on real machines and
the provided preseed files may also be used to install identical systems on
bare metal as well.

While there are no limitations running 32-bit x86 guests on 64-bit x86 hosts,
this functionality has been deprecated here since 32-bit support is being
phased out of Debian/Ubuntu "real soon now".


What dependencies does this have?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

These templates are tested semi-regularly on Linux (Debian) hosts using recent
versions of Packer and Vagrant.  All testing is currently done on systems that
have amd64/x86_64-family processors.

The QEMU and VirtualBox versions used for Linux testing are normally the
"stock" ones provided by the official Debian repositories.

* REQUIRED:  Packer_ (Packer_download_)

  - 0.10.2 on Debian Jessie 8.x (with VirtualBox and QEMU)
  - 0.10.1 on Mac OS El Capitan 10.11.x (with VirtualBox)

.. _Packer: https://packer.io
.. _Packer_download: https://releases.hashicorp.com/packer

* REQUIRED (if not using QEMU):  VirtualBox_ (VirtualBox_download_)

  - 4.3.36 r105129 [4.3.36-dfsg-1+deb8u1] on Debian Jessie 8.x
  - 5.1.4 r110228 on Mac OS El Capitan 10.11.x

.. _VirtualBox: https://virtualbox.org
.. _VirtualBox_download: http://download.virtualbox.org/virtualbox

* REQUIRED (if not using VirtualBox):  QEMU_ (kvm_)

  - 2.1.2 [Debian 1:2.1+dfsg-12+deb8u6] or newer on Debian Jessie 8.x
  - not tested on Mac OS (does this even work?)

.. _QEMU: http://qemu.org
.. _kvm: http://linux-kvm.org

* OPTIONAL:  Vagrant_ (Vagrant_download_)

  - 1.8.6 on Debian Jessie 8.x (with VirtualBox)
  - 1.8.5 on Mac OS El Capitan 10.11.x (with VirtualBox)

.. _Vagrant: https://vagrantup.com
.. _Vagrant_download: https://releases.hashicorp.com/vagrant

* BIG, BIG MAYBE:  vagrant-libvirt_ plugin (for QEMU support in Vagrant)

  - Please refer to their page for version information, installation
    instructions and dependencies.

.. _vagrant-libvirt: https://github.com/vagrant-libvirt/vagrant-libvirt

Even though Packer supports QEMU as an officially-supported provider, Vagrant,
for some reason, does not.  The 3rd-party plugin named "vagrant-libvirt"
provides the missing QEMU support for Vagrant.  We are unable at this time to
verify this fact due to the following errors encountered while trying to run
"vagrant up"::

    Error while connecting to libvirt: Error making a connection to libvirt URI qemu:///system?no_verify=1&keyfile=/home/whoa/.ssh/id_rsa:
    Call to virConnectOpen failed: Failed to connect socket to '/var/run/libvirt/libvirt-sock': No such file or directory


TODO Items
~~~~~~~~~~

* Get proper templating working for the preseed and vagrant files
* Replace Ruby json2yaml and yaml2json scripts with non-ugly Python ones
* Make sure to use comparable cpus and cores_per_cpu for qemu and vbox
* [Debian preseeds] Find out if partman-crypto will allow passphrase-crypted
* [Debian preseeds] Skip past "Force UEFI Install" installer prompt


Using Packer Templates
----------------------

Usage::

    ./scripts/vbox.sh [PACKER_OPTIONS] PACKER_TEMPLATE
    ./scripts/qemu.sh [PACKER_OPTIONS] PACKER_TEMPLATE

Examples::

    ./scripts/vbox.sh debian/stretch/base-stretch.json
    ./scripts/vbox.sh -var vm_name=test -var version=1.0.0 \
        debian/stretch/base-stretch.json
    ./scripts/qemu.sh -var-file=variables.json \
        debian/stretch/base-stretch.json

Contents of example file ``variables.json`` used above::

    {
      "vm_name": "test",
      "version": "1.0.0"
    }

To verify your templates, force them to be re-sorted and/or to upgrade your
templates whenever the version of Packer changes::

    ./scripts/generate_templates.sh


Using Vagrant Box Files
-----------------------

A Vagrant box file is actually a regular gzipped tar archive containing...

* box.ovf - Open Virtualization Format XML descriptor file
* nameofmachine-disk1.vmdk - a virtual hard drive image file
* Vagrantfile - derived from 'Vagrantfile.template'
* metadata.json - containing just '{ "provider": "virtualbox" }'

An OVA file is actually a regular tar archive containing identical copies of
the first 2 files that you would normally see in a Vagrant box file (but the
OVF file may be named nameofmachine.ovf and it *must* be the first file or
VirtualBox will get confused).

To create and use a Vagrant box file without a dedicated Vagrantfile::

    ./scripts/vbox.sh -var version=1.0.0 debian/stretch/base-stretch.json
    vagrant box add myname/stretch build/2015-06-31-12-34/base-stretch-1.0.0.virtualbox.box
    vagrant init myname/stretch
    vagrant up
    vagrant ssh
    ...
    vagrant destroy

In order to version things and self-host the box files, you will need to create
a JSON file containing the following::

    {
      "name": "base-stretch",
      "description": "Base box for 64-bit x86 Debian Stretch 9.x",
      "versions": [
        {
          "version": "1.0.0",
          "providers": [
            {
              "name": "virtualbox",
              "url": "http://server/vm/base-stretch/base-stretch-1.0.0-virtualbox.box",
              "checksum_type": "sha256",
              "checksum": "THESHA256SUMOFTHEBOXFILE"
            }
          ]
        }
      ]
    }

SHA256 hashes are the largest ones that Vagrant supports, currently.

Then, simply make sure you point your Vagrantfile at this version payload::

    Vagrant.configure(2) do |config|
      config.vm.box = "base-stretch"
      config.vm.box_url = "http://server/vm/base-stretch/base-stretch.json"

      config.vm.synced_folder ".", "/vagrant", disabled: true
    end

* https://github.com/hollodotme/Helpers/blob/master/Tutorials/vagrant/self-hosted-vagrant-boxes-with-versioning.md
* http://blog.el-chavez.me/2015/01/31/custom-vagrant-cloud-host/
* https://www.nopsec.com/news-and-resources/blog/2015/3/27/private-vagrant-box-hosting-easy-versioning/


Making Bootable Drives
----------------------

For best results, you should use the Packer QEMU "kvm" builder when trying to
create bootable images to be used on real hardware.  This allows the use of the
"raw" block device format which is ideal for writing directly directly to USB
and SATA drives.  Alternately, you may use "qemu-img convert" or "vbox-img
convert" to convert an exiting image in another format to raw mode::

    ./scripts/qemu.sh debian/stretch/base-stretch.json
    zcat build/2099-06-31-12-34/base-stretch.raw.gz | dd of=/dev/sdb bs=4M

... Or, if you just want to "boot" it::

    qemu-system-x86_64 -m 512M -machine type=pc,accel=kvm build/2015-06-31-12-34/base-stretch.raw


Overriding Local ISO Cache Location
-----------------------------------

You may override the default directory used instead of './packer_cache' by
specifying it with the environment variable 'PACKER_CACHE_DIR'::

    PACKER_CACHE_DIR=/tmp packer build -only=vbox \
        debian/stretch/base-stretch.json

You must *always* specify the PACKER_CACHE_DIR when using the provided
templates due to a problem in packer where the PACKER_CACHE_DIR is not provided
to the template if one was not provided;  In this case, it will fall back to
the default value of "./packer_cache".


Disabling Hashicorp Checkpoint Version Checks
---------------------------------------------

Both Packer and Vagrant will contact Hashicorp with some anonymous information
each time it is being run for the purposes of announcing new versions and other
alerts.  If you would prefer to disable this feature, simply add the following
environment variables::

    CHECKPOINT_DISABLE=1
    VAGRANT_CHECKPOINT_DISABLE=1

* https://checkpoint.hashicorp.com/
* https://github.com/hashicorp/go-checkpoint
* https://docs.vagrantup.com/v2/other/environmental-variables.html


UEFI Booting on VirtualBox
--------------------------

It isn't necessary to perform this step when running on real hardware, however,
VirtualBox (4.3.28) seems to have a problem if you don't perform this step.

* http://ubuntuforums.org/showthread.php?t=2172199&p=13104689#post13104689

To examine the actual contents of the file after editing it::

    hexdump /boot/efi/startup.nsh


Using the EFI Shell Editor
~~~~~~~~~~~~~~~~~~~~~~~~~~

To enter the UEFI shell text editor from the UEFI prompt::

    edit startup.nsh

Type in the stuff to add to the file (the path to the UEFI blob)::

    FS0:\EFI\debian\grubx64.efi

To exit the UEFI shell text editor::

    ^S
    ^Q

Hex Result::

    0000000 feff 0046 0053 0030 003a 005c 0045 0046
    0000010 0049 005c 0064 0065 0062 0069 0061 006e
    0000020 005c 0067 0072 0075 0062 0078 0036 0034
    0000030 002e 0065 0066 0069
    0000038


Using Any Old 'nix' Text Editor
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

To populate the file in a similar manner to the UEFI Shell method above::

    echo 'FS0:\EFI\debian\grubx64.efi' > /boot/efi/startup.nsh

Hex Result::

    0000000 5346 3a30 455c 4946 645c 6265 6169 5c6e
    0000010 7267 6275 3678 2e34 6665 0a69
    000001c


Serving Local Files via HTTP
----------------------------

::

    ./scripts/sow.py


Caching Debian/Ubuntu Packages
------------------------------

If you wish to speed up fetching lots of Debian and/or Ubuntu packages, you
should probably install "apt-cacher-ng" on a machine and then add the following
to each machine that should use the new cache::

    echo "Acquire::http::Proxy 'http://localhost:3142';" >>\
        /etc/apt/apt.conf.d/99apt-cacher-ng

You must re-run "apt-cache update" each time you add or remove a proxy.  If you
populate the "d-i http/proxy string" value in your preseed file, all this stuff
will have been done for you already.


Preseed Documentation
---------------------

* https://www.debian.org/releases/stable/amd64/
* https://help.ubuntu.com/lts/installation-guide/amd64/index.html


Other
-----

* http://www.preining.info/blog/2014/05/usb-stick-tails-systemrescuecd/

* https://5pi.de/2015/03/13/building-aws-amis-from-scratch/
* http://www.scalehorizontally.com/2013/02/24/introduction-to-cloud-init/
* https://julien.danjou.info/blog/2013/cloud-init-utils-debian
* http://thornelabs.net/2014/04/07/create-a-kvm-based-debian-7-openstack-cloud-image.html

* http://blog.codeship.com/packer-ansible/
* https://servercheck.in/blog/server-vm-images-ansible-and-packer

* http://ariya.ofilabs.com/2013/11/using-packer-to-create-vagrant-boxes.html
* http://blog.codeship.io/2013/11/07/building-vagrant-machines-with-packer.html
* https://groups.google.com/forum/#!msg/packer-tool/4lB4OqhILF8/NPoMYeew0sEJ
* http://pretengineer.com/post/packer-vagrant-infra/
* http://stackoverflow.com/questions/13065576/override-vagrant-configuration-settings-locally-per-dev

* https://djaodjin.com/blog/deploying-on-ec2-with-ansible.blog.html

* https://github.com/jpadilla/juicebox
* https://github.com/boxcutter/ubuntu
* https://github.com/katzj/ami-creator


Why did you use the Ubuntu Server installer to create desktop systems?
----------------------------------------------------------------------

* http://askubuntu.com/questions/467804/preseeding-does-not-work-properly-in-ubuntu-14-04
* https://wiki.ubuntu.com/UbiquityAutomation


Offical ISO Files
-----------------

Debian_
~~~~~~

.. _Debian: https://www.debian.org

* Testing;  http://cdimage.debian.org/cdimage/weekly-builds/amd64/iso-cd/
* Stable;  http://cdimage.debian.org/cdimage/release/current/amd64/iso-cd/
* Oldstable;  http://cdimage.debian.org/cdimage/archive/latest-oldstable/amd64/iso-cd/

Ubuntu_
~~~~~~

.. _Ubuntu: http://ubuntu.com

* Released;  http://releases.ubuntu.com
* Pending;  http://cdimage.ubuntu.com/ubuntu-server/daily/current/


Distro Release Names
--------------------

Debian_releases_
~~~~~~~~~~~~~~~

.. _Debian_releases: https://en.wikipedia.org/wiki/List_of_Debian_releases#Release_table

* Bullseye (11.x);  released on 20??-??-??, supported until 20??-??-??
* Buster (10.x);  released on 20??-??-??, supported until 20??-??-??
* Stretch (9.x);  released on 20??-??-??, supported until 20??-??-??
* Jessie (8.x);  released on 2015-04-26, supported until 2020-0[45]-??
* Wheezy (7.x);  released on 2013-05-04, supported until 2018-05-??

Ubuntu_releases_
~~~~~~~~~~~~~~~

.. _Ubuntu_releases: https://en.wikipedia.org/wiki/List_of_Ubuntu_releases#Table_of_versions

* Z Z (17.04);  released on 2017-04-??, supported until 2018-??-??
* Yakkety Yak (16.10);  released on 2016-10-20, supported until 2017-07-??
* Xenial Xerus (16.04.x LTS);  released on 2016-04-21, supported until 2021-04-??
* Trusty Tahr (14.04.x LTS);  released on 2014-04-17, supported until 2019-04-??
* Precise Pangolin (12.04.x LTS);  released on 2012-04-26, supported until 2017-04-26
