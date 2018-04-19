### bootable USB 
```bash
dd bs=512 if=/path/to/iso of=/dev/sdx && sync
```

### labels 
```bash
if your label is GPT:
    parted /dev/sda
    mklabel msdos
    quit
```

### partitioning 
```bash
fdisk /dev/sda
    # make mbr partition table (it's for BIOS, GPT is for UEFI)
    n - new partition
    ...
    a - makes bootable
    p - print all partitions
    l - list of partition codes
    t - change type of partitions
        82 - swap
        83 - Linux
    d - delete partitions
    w - write changes
```

```bash    
mkswap /dev/sdaS (S - swap partition)
swapon /dev/sdaS
mkfs.ext4 /dev/sdaR (R - /root partition)
mkfs.ext4 /dev/sdaH (H - /home partition)
mount /dev/sdaR /mnt
mkdir -p /mnt/boot
mkdir -p /mnt/home
mount /dev/sdaH /mnt/home (H - home partition)
```

### check for Internet connection
```bash
wifi-menu
ping -c 3 wp.pl
pacman -Sy
```
 
### choose closest mirror
```bash
pacman -S reflector     
reflector --verbose -l 5 --sort rate --save /etc/pacman.d/mirrorlist
```

### pacstrap script installs the base system
```bash
pacstrap /mnt base base-devel
```

### generate an fstab file
```bash
genfstab -U -p /mnt >> /mnt/etc/fstab
cat /mnt/etc/fstab
```

### chroot 
This is an operation that changes the apparent root directory for the current running process and their children
```bash
arch-chroot /mnt
```

### regional settings for Poland
```bash
echo arch > /etc/hostname
cp /usr/share/zoneinfo/Europe/Warsaw /etc/localtime
nano /etc/locale.gen
    > uncomment two lines with pl
locale-gen
```

### change root password
```bash
passwd
```

### install grub
```bash
pacman -S grub
grub-install /dev/sda
nano /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg
```

### create an initial ramdisk environment
```bash
mkinitcpio -p linux
```

### config pacman
```bash
nano /etc/pacman.conf
    > uncomment Color
    > uncomment Multilib (if x64)
pacman -Syyu
```

### install wicd stuff
```bash
pacman -S wireless_tools wpa_supplicant wpa_actiond dialog
```

```bash
# Install dependencies for my script
pacman -S git libnewt
```

### reboot
```bash
exit
umount -R /mnt
reboot
> boot existing OS
> arch login: root
> password: you've typed this earlier
```

### add new user
```bash
useradd -m -g users -G wheel,games,audio,video,storage,power \
-s /bin/bash <username>
chfn <username>
passwd <username>
pacman -S sudo
visudo
> uncomment line with wheel
reboot
> login as a user
```

### run my own script
```bash
mkdir repo
cd repo
git clone git@github.com:dudekmichal/arch.git 
chmod +x $HOME/repo/arch/arch.sh
$HOME/repo/arch/arch.sh
```
