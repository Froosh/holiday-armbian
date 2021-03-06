# DO NOT EDIT THIS FILE
#
# Please edit /boot/armbianEnv.txt to set supported parameters
#

setenv fdt_addr 0x41000000
setenv kernel_addr 0x42000000
setenv ramdisk_addr 0x42A00000

setenv fdt_file imx23-holiday.dtb

# default values
setenv rootdev "/dev/mmcblk${mmcdev}p3"
setenv rootfstype "ext4"
setenv verbosity "7"

echo "Boot script loaded from mmc ${mmcdev}:${mmcpart}"

if test -e mmc ${mmcdev}:${mmcpart} ${prefix}armbianEnv.txt; then
	load mmc ${mmcdev}:${mmcpart} ${loadaddr} ${prefix}armbianEnv.txt
	env import -t ${loadaddr} ${filesize}
	echo "Environment loaded from mmc ${mmcdev}:${mmcpart} armbianEnv.txt"
fi

setenv consoleargs "console=${console},${baudrate}n8"

setenv bootargs "earlyprintk root=${rootdev} ro rootwait rootfstype=${rootfstype} ${consoleargs} loglevel=${verbosity} usb-storage.quirks=${usbstoragequirks} ${extraargs} ${extraboardargs}"

load mmc ${mmcdev}:${mmcpart} ${fdt_addr} ${prefix}dtb/${fdt_file}
fdt addr ${fdt_addr}
fdt resize 65536

load mmc ${mmcdev}:${mmcpart} ${ramdisk_addr} ${prefix}uInitrd
setenv ramdisk_size $filesize

load mmc ${mmcdev}:${mmcpart} ${kernel_addr} ${prefix}zImage

bootz ${kernel_addr} ${ramdisk_addr}:${ramdisk_size} ${fdt_addr}

# Recompile with:
# mkimage -C none -A arm -T script -d /boot/boot.cmd /boot/boot.scr
