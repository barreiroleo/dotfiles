# Reorder partitions
Source: https://unix.stackexchange.com/questions/18752/change-the-number-of-the-partition-from-sda1-to-sda2
To get order on partitions like this:
/dev/sda1 /dev/sda3 /dev/sda2 → /dev/sda1 /dev/sda2 /dev/sda3
```
sudo fdisk /dev/sdX
```
Then:
- x to enter Expert Mode
- f to fix the drive order (possibly i to ignore any warnings if required)
- r to return to normal mode
- w to write changes to the disk and exit


# Mount /opt directory on external disk
```
sudo vim /etc/fstab
```
Make the /opt directory on the target partition.
Past after automatic mount of the partition that you desire the end of fstab.
/dev/sda3/opt                      /opt      none bind 0 0


# Regenerate XDG-DIRS folders on $HOME. (English)
LC_ALL=C xdg-user-dirs-update --force

# Reset gnome configs
dconf reset -f /org/gnome/
