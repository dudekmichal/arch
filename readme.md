### bootable USB 
```bash
dd bs=512 if=/path/to/iso of=/dev/sdx && sync  # and boot from usb in efi mode
```

### enable the NTP service
```bash
timedatectl set-ntp true
```

### partitioning 
```bash
cfdisk
> create Linux filesystem
```

```bash    
mkswap /dev/sdaS (S - swap partition)
swapon /dev/sdaS
mkfs.ext4 /dev/sdaR (R - /root partition)
mkfs.ext4 /dev/sdaH (H - /home partition)
mount /dev/sdaR /mnt
mkdir -p /mnt/boot
mkdir -p /mnt/home
mount /dev/sdaH /mnt/home
```

### check for Internet connection
```bash
wifi-menu
ping -c 3 google.com
pacman -Sy
```
 
### choose closest mirror
```bash
pacman -S reflector     
reflector --verbose -l 5 --sort rate --save /etc/pacman.d/mirrorlist
```

### pacstrap script installs the base system
```bash
pacstrap /mnt base base-devel linux linux-firmware vim grub
```

### generate a fstab file
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
ln -sf /usr/share/zoneinfo/Europe/Warsaw /etc/localtime
vim /etc/locale.gen
    > uncomment your locale
locale-gen
echo "LANG=pl_PL.UTF-8" > etc/locale.conf

hwclock --systohc  # set hardware clock
```

### change root password
```bash
passwd
```

### install grub
```bash
grub-install --target=x86_64-efi --efi-directory=/efi/ --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg
```

### config pacman
```bash
vim /etc/pacman.conf
    > uncomment Color
    > uncomment Multilib (if x64)
pacman -Syyu
```

### install additional tools
```bash
pacman -Sy netctl dialog dhcpcd xorg xorg-server grub efibootmgr os-prober gnome gnome-tweaks gnome-calendar terminus-font neofetch zsh git sudo audacious openssh
```

### add new user
```bash
useradd -G wheel,games,audio,video,storage,power -s /bin/zsh <username>
passwd <username>
visudo
> uncomment line with wheel
```

### reboot
```bash
exit
umount -R /mnt
reboot
> boot existing OS
```

### network setup
```bash
cd /etc/netctl
sudo cp examples/ethernet-dhcp ./custom-dhcp-profile
sudo vim custom-dhcp-profile
> set interface to your interface (eg enp4s0)
> uncomment DHCPCDClient

netctl enable custom-dhcp-profile
systemctl enable dhcpcd.service
sudo systemctl enable gdm.service
reboot
ping google.com
```

### ssh keys
```bash
ssh-keygen
```
