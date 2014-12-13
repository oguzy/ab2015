#installing the dependenciesi for kernel compile
sudo su -
apt-get install fakeroot build-essential
apt-get install crash kexec-tools makedumpfile kernel-wedge
apt-get build-dep linux-image-$(uname -r)
apt-get install git libncurses5 libncurses5-dev libnewt-dev


apt-get source linux-image-`uname -r`
cd linux-3.13.0
chmod a+x debian/scripts/*
chmod a+x debian/scripts/misc/*

cp /boot/config-`uname -r` debian.master/config/amd64/config.flavour.ab2015
fakeroot debian/rules clean
debian/rules updateconfigs

debian/rules editconfigs
# Do you want to edit config: amd64/config.flavour.ab2015? [Y/n]

#File: debian.master/etc/getabis

#Search for the line:
#getall amd64 generic virtual

#Change it in:
#getall amd64 generic virtual ab2015

#File: debian.master/rules.d/amd64.mk

#Search for the line:
#flavours        = generic virtual

#Change it in:
#flavours        = generic virtual ab2015

#File: debian.master/control.d/vars.ab2015

#This files does not exist and in order to make the compilation process aware of our own flavor we want to compile we need to create it.
#cp debian.master/control.d/vars.generic debian.master/control.d/vars.ab2015

#You can edit the file and make it your own.
#arch="i386 amd64"
#supported="i7 Processor"
#target="Geared toward i7 desktop systems."
#desc="x86/x86_64"
#bootloader="grub-pc | grub-efi-amd64 | grub-efi-ia32 | grub | lilo (>= 19.1)"
#provides="kvm-api-4, redhat-cluster-modules, ivtv-modules, ndiswrapper-modules-1.9"

skipabi=true skipmodule=true fakeroot debian/rules binary-ab2015
