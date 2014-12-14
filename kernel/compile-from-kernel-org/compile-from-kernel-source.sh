wget https://www.kernel.org/pub/linux/kernel/v3.x/linux-3.17.6.tar.xz

lspci
lspci -v
lsusb
lsusb -v
lsmod

tar xvJf linux-3.17.6.tar.xz
cd linux-3.17.6
# for cleaning the directory
# This ensures that the kernel tree is absolutely clean. The kernel team recommends that this command be issued prior to each kernel compilation. Do not rely on the source tree being clean after un-tarring. 
make mrproper


#Make oldconfig -- asks you questions on what the kernel should support one by one, very time consuming.
#Make menuconfig -- creates a menu where you can browse options on what the kernel supports. Requires ncurses library, but that is likely already on your computer.
#Make qconfig/xconfig/gconfig -- same as menuconfig, except that now the configuration menu is graphics based."qconfig" Requires the QT library.
#Use configuration of current kernel. Run this from your kernel source folder "cp /boot/config-`uname -r` .config". This saves a lot of time, but you may want to change version number of the to be compiled kernel to avoid replacing your current kernel. "General setup" --> "Local version - append to kernel release". Example if the kernel version number is 3.13.0, you can example write there 3.13.0.RC1.

cp /boot/config-`uname -r` .config
make menuconfig

make -j 3
sudo make modules_install
sudo make install

cd /boot
# initrd images contains device driver which needed to load rest of the operating system later on. Not all computer requires initrd, but it is safe to create one.
mkinitinitramfs -o initrd.img-3.17.6RC1 3.17.6RC1

# edit /etc/grub.d/40_custom

uname -a
uname -s # Produces the name of the kernel which is normally linux 
# equals
# cat /proc/sys/kernel/ostype
uname -n # nodename, display the network hostname
uname -r # displays the kernel release number
uname -m # machine type
uname -p # cpu tyoe
uname -o # operaating system
uname -v # kernel version
# cat /proc/sys/kernel/version
