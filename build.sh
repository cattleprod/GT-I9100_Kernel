#!/bin/bash

# Set Default Path
TOP_DIR=$PWD
KERNEL_PATH=/home/legend/android/kernel/GT-I9100_Kernel

# TODO: Set toolchain and root filesystem path
TAR_NAME=zImage.tar

TOOLCHAIN="/home/legend/android/toolchains/4.5.4/android-toolchain-eabi/bin/arm-eabi-"
# TOOLCHAIN="/home/neophyte-x360/toolchain/bin/arm-none-eabi-"
ROOTFS_PATH="/home/legend/android/initramfs/HK3/"



echo "Cleaning latest build"
make ARCH=arm CROSS_COMPILE=$TOOLCHAIN -j`grep 'processor' /proc/cpuinfo | wc -l` clean

cp -f $KERNEL_PATH/arch/arm/configs/XCeLL-defconfig $KERNEL_PATH/.config

make -j4 -C $KERNEL_PATH xconfig || exit -1
make -j4 -C $KERNEL_PATH ARCH=arm CROSS_COMPILE=$TOOLCHAIN || exit -1

cp drivers/bluetooth/bthid/bthid.ko $ROOTFS_PATH/lib/modules/
cp drivers/net/wireless/bcm4330/dhd.ko $ROOTFS_PATH/lib/modules/
cp drivers/samsung/j4fs/j4fs.ko $ROOTFS_PATH/lib/modules/
cp drivers/samsung/fm_si4709/Si4709_driver.ko $ROOTFS_PATH/lib/modules/
cp drivers/scsi/scsi_wait_scan.ko $ROOTFS_PATH/lib/modules/
cp drivers/samsung/vibetonz/vibrator.ko $ROOTFS_PATH/lib/modules/

make -j4 -C $KERNEL_PATH ARCH=arm CROSS_COMPILE=$TOOLCHAIN || exit -1

# Copy Kernel Image
cp -f $KERNEL_PATH/arch/arm/boot/zImage .

cd arch/arm/boot
tar cf $KERNEL_PATH/arch/arm/boot/$TAR_NAME zImage && ls -lh $TAR_NAME
