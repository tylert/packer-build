packer-build
============


What does this do?
~~~~~~~~~~~~~~~~~~

These Packer templates and associated files may be used to build fresh Debian
and Ubuntu virtual machine images for Vagrant, VirtualBox and QEMU.

The resulting image files may be used as bootable systems on real machines and
the provided preseed files may also be used to install identical systems on
bare metal as well.

While there are no limitations for running 32-bit x86 guests on 64-bit x86
hosts, this functionality has been deprecated here since 32-bit support is
being phased out of Debian/Ubuntu "real soon now".


What dependencies does this have?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

These templates are tested semi-regularly on recent Linux (Debian and/or
Ubuntu) hosts using recent versions of Packer and Vagrant.  All testing is
currently done on systems that have amd64/x86_64-family processors.

The VirtualBox and QEMU versions used for Linux testing are normally the
"stock" ones provided by the official distribution repositories.

* REQUIRED:  Packer_ (Packer_download_)

  - 1.5.1 on Debian Buster 10.x (VirtualBox and QEMU)
  - not currently being tested on macOS but used to work fine

.. _Packer:  https://www.packer.io/
.. _Packer_download:  https://releases.hashicorp.com/packer/

* REQUIRED (if not using QEMU):  VirtualBox_ (VirtualBox_download_)

  - 5.1.34 r121010 (Qt5.7.1) [5.1.34-121010~Debian~stretch] on Debian Buster 10.x
  - not currently being tested on macOS but used to work fine

.. _VirtualBox:  https://www.virtualbox.org/
.. _VirtualBox_download:  http://download.virtualbox.org/virtualbox

* REQUIRED (if not using VirtualBox):  QEMU_ (kvm_)

  - 3.1.0 (Debian 1:3.1+dfsg-8+deb10u3) [3.1+dfsg-8+deb10u3] on Debian Buster 10.x
  - not currently being tested on macOS but used to work fine

.. _QEMU:  https://www.qemu.org/
.. _kvm:  https://www.linux-kvm.org/page/Main_Page

* OPTIONAL:  Vagrant_ (Vagrant_download_)

  - 2.2.6 on Debian Buster 10.x (VirtualBox)
  - not currently being tested on macOS but used to work fine

.. _Vagrant:  https://www.vagrantup.com/
.. _Vagrant_download:  https://releases.hashicorp.com/vagrant/

* BIG, BIG MAYBE:  vagrant-libvirt_ plugin (QEMU provider for Vagrant)

  - Please refer to their page for version information, installation
    instructions and dependencies.

.. _vagrant-libvirt:  https://github.com/vagrant-libvirt/vagrant-libvirt

Even though Packer supports QEMU as an officially-supported provider, Vagrant,
for some reason, does not.  The 3rd-party plugin named "vagrant-libvirt"
provides the missing QEMU support for Vagrant.  We are unable at this time to
verify this fact due to the following errors encountered while trying to run
"vagrant up"::

    Error while connecting to libvirt: Error making a connection to libvirt URI qemu:///system?no_verify=1&keyfile=/home/whoa/.ssh/id_rsa:
    Call to virConnectOpen failed: Failed to connect socket to '/var/run/libvirt/libvirt-sock': No such file or directory

It may be possible to correct this error by installing the
`libvirt-daemon-system` package on Debian.


TODO Items
~~~~~~~~~~

* Get proper templating working for the preseed and vagrant files
* [preseed debian] Find out if partman-crypto will allow passphrase-crypted
* [preseed debian] Skip past "Force UEFI Install" installer prompt
* [template qemu] Correct generated filenames for images to end in .img{,.gz}
* [template vagrant] Dump checksum into vagrant manifest file + convert to JSON


Using Packer Templates
----------------------

You must first generate templates using::

    ./script/generate_templates.sh

Then, you may run them using one or more of the following::

    packer [PACKER_OPTIONS] PACKER_TEMPLATE

Examples::

    packer build -only=vbox template/debian/11_bullseye/base.json

    packer build -only=qemu -var=headless=true -var=version=1.0.0 -var=vm_name=test \
        template/debian/11_bullseye/base.json

    packer build -var-file=variables.json template/debian/11_bullseye/base.json

Contents of example file ``variables.json`` used above::

    {
      "headless": true,
      "version": "1.0.0",
      "vm_name": "test"
    }


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

    packer build -only=vbox -var=version=1.0.0 template/debian/11_bullseye/base.json
    vagrant box add myname/bullseye \
        build/2038-01-19-03-14/base-bullseye-1.0.0.virtualbox.box
    vagrant init myname/bullseye
    vagrant up
    vagrant ssh
    ...
    vagrant destroy

In order to version things and self-host the box files, you will need to create
a JSON file containing the following::

    {
      "name": "base-bullseye",
      "description": "Base box for 64-bit x86 Debian Bullseye 11.x",
      "versions": [
        {
          "version": "1.0.0",
          "providers": [
            {
              "name": "virtualbox",
              "url": "http://server/vm/base-bullseye/base-bullseye-1.0.0-virtualbox.box",
              "checksum_type": "sha256",
              "checksum": "THESHA256SUMOFTHEBOXFILE"
            }
          ]
        }
      ]
    }

SHA256 hashes are the largest ones that Vagrant supports, currently.

Then, simply make sure you point your Vagrantfile at this version payload::

    Vagrant.configure('2') do |config|
      config.vm.box = 'base-bullseye'
      config.vm.box_url = 'http://server/vm/base-bullseye/base-bullseye.json'

      config.vm.synced_folder '.', '/vagrant', disabled: true
    end

NOTE:  You must ensure you disable the synched folder stuff above or you will
encounter the following error::

    Vagrant was unable to mount VirtualBox shared folders. This is usually
    because the filesystem "vboxsf" is not available. This filesystem is
    made available via the VirtualBox Guest Additions and kernel module.
    Please verify that these guest additions are properly installed in the
    guest. This is not a bug in Vagrant and is usually caused by a faulty
    Vagrant box. For context, the command attempted was:

    mount -t vboxsf -o uid=1000,gid=1000 vagrant /vagrant

    The error output from the command was:

    mount: unknown filesystem type 'vboxsf'

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

    packer build -only=qemu template/debian/11_bullseye/base.json
    zcat build/2038-01-19-03-14/base-bullseye.raw.gz | dd of=/dev/sdz bs=4M

... Or, if you just want to "boot" it::

    qemu-system-x86_64 -m 512M -machine type=pc,accel=kvm \
        build/2038-01-19-03-14/base-bullseye.raw


Overriding Local ISO Cache Location
-----------------------------------

You may override the default directory used instead of './packer_cache' by
specifying it with the environment variable 'PACKER_CACHE_DIR'::

    PACKER_CACHE_DIR=/tmp packer build -only=vbox \
        template/debian/11_bullseye/base.json

You must *always* specify the PACKER_CACHE_DIR when using the provided
templates due to a problem in packer where the PACKER_CACHE_DIR is not provided
to the template if one was not provided;  In this case, it will fall back to
the default value of "./packer_cache".


Overriding Local VM Cache Location
----------------------------------

::

    vboxmanage setproperty machinefolder ${HOME}/vm


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

    ./script/sow.py


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
* http://jackstromberg.com/2012/12/how-to-export-a-vm-from-amazon-ec2-to-vmware-on-premise/
* https://docs.aws.amazon.com/cli/latest/reference/ec2/create-instance-export-task.html

* https://github.com/jpadilla/juicebox
* https://github.com/boxcutter/ubuntu
* https://github.com/katzj/ami-creator


Why did you use the Ubuntu Server installer to create desktop systems?
----------------------------------------------------------------------

* http://askubuntu.com/questions/467804/preseeding-does-not-work-properly-in-ubuntu-14-04
* https://wiki.ubuntu.com/UbiquityAutomation


Building Windows VMs
--------------------

* http://www.hurryupandwait.io/blog/creating-windows-base-images-for-virtualbox-and-hyper-v-using-packer-boxstarter-and-vagrant
* https://github.com/mwrock/packer-template
* https://github.com/joefitzgerald/packer-windows
* https://gist.github.com/joefitzgerald/8203265
* https://github.com/mefellows/packer-community-templates
* https://blogs.technet.microsoft.com/secguide/2016/01/21/lgpo-exe-local-group-policy-object-utility-v1-0/
* https://github.com/rgl/packer-provisioner-windows-update


Using a Headless Server
-----------------------

If you are using these scripts on a "headless" server (i.e.:  no GUI), you must
set the "headless" variable to "true" or you will encounter the following
error::

    ...
    ==> virtualbox: Starting the virtual machine...
    ==> virtualbox: Error starting VM: VBoxManage error: VBoxManage: error: The virtual machine 'base-bullseye' has terminated unexpectedly during startup because of signal 6
    ==> virtualbox: VBoxManage: error: Details: code NS_ERROR_FAILURE (0x80004005), component MachineWrap, interface IMachine
    ...


Offical ISO Files
-----------------


Debian_
~~~~~~

.. _Debian:  https://www.debian.org/

* Testing;  http://cdimage.debian.org/cdimage/weekly-builds/amd64/iso-cd/
* Stable;  http://cdimage.debian.org/cdimage/release/current/amd64/iso-cd/
* Oldstable;  http://cdimage.debian.org/cdimage/archive/latest-oldstable/amd64/iso-cd/


Ubuntu_
~~~~~~

.. _Ubuntu:  https://www.ubuntu.com/

* Netboot;  http://cdimage.ubuntu.com/netboot/
* Released;  http://releases.ubuntu.com/
* Pending;  http://cdimage.ubuntu.com/ubuntu-server/daily/current/


Distro Release Names
--------------------


Debian_releases_
~~~~~~~~~~~~~~~

.. _Debian_releases:  https://en.wikipedia.org/wiki/Debian_version_history#Release_table

* Bookworm (12.x);  released on 2023?-??-??, supported until 2028?-??-01
* Bullseye (11.x);  released on 2021?-??-??, supported until 2026?-??-01
* Buster (10.x);  released on 2019-07-06, supported until 2024-??-01
* Stretch (9.x);  released on 2017-06-18, supported until 2022-06-01
* Jessie (8.x);  released on 2015-04-26, supported until 2020-06-30


Ubuntu_releases_
~~~~~~~~~~~~~~~

.. _Ubuntu_releases:  https://en.wikipedia.org/wiki/Ubuntu_version_history#Table_of_versions

* Focal Fossa (20.04.x LTS);  released on 2020-04-23?, supported until 2025-04-01
* Eoan Ermine (19.10.x);  released on 2019-10-17, supported until 2020-07-01
* Bionic Beaver (18.04.x LTS);  released on 2018-04-26, supported until 2023-04-01
* Xenial Xerus (16.04.x LTS);  released on 2016-04-21, supported until 2021-04-01

(LTS releases are usually supported for 5 years and non-LTS releases are
usually supported for 9 to 11 months)
