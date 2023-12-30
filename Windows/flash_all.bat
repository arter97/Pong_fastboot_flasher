@echo off
title Nothing Phone 2 Fastboot ROM Flasher (t.me/NothingPhone2)

echo #################################################
echo #           Pong Fastboot ROM Flasher           #
echo #              Developed/Tested By              #
echo #  Hellboy017, Ali Shahawez, Spike, Phatwalrus  #
echo #     [Nothing Phone (2) Telegram Dev Team]     #
echo #################################################

echo #############################
echo # CHANGING ACTIVE SLOT TO A #
echo #############################
fastboot --set-active=a

echo ###################
echo # FORMATTING DATA #
echo ###################
choice /m "Wipe Data?"
if %errorlevel% equ 1 (
    fastboot -w
)

echo ##########################
echo # FLASHING BOOT/RECOVERY #
echo ##########################
for %%i in (boot vendor_boot dtbo recovery) do (
    fastboot flash %%i %%i.img
)

echo ##########################             
echo # REBOOTING TO FASTBOOTD #       
echo ##########################
fastboot reboot fastboot

echo #####################
echo # FLASHING FIRMWARE #
echo #####################
choice /m "Flash firmware on both slots?"
if %errorlevel% equ 1 (
    for %%i in (abl aop bluetooth cpucp devcfg dsp featenabler hyp imagefv keymaster modem multiimgoem multiimgqti qupfw qweslicstore shrm tz uefi uefisecapp xbl xbl_config xbl_ramdump) do (
        fastboot flash --slot=all %%i %%i.img
    )
) else (
    for %%i in (abl aop bluetooth cpucp devcfg dsp featenabler hyp imagefv keymaster modem multiimgoem multiimgqti qupfw qweslicstore shrm tz uefi uefisecapp xbl xbl_config xbl_ramdump) do (
        fastboot flash %%i %%i.img
    )
)

echo ###############################
echo # RESIZING LOGICAL PARTITIONS #
echo ###############################
for %%i in (odm_a system_a system_ext_a product_a vendor_a vendor_dlkm_a odm_b system_b system_ext_b product_b vendor_b vendor_dlkm_b) do (
    fastboot delete-logical-partition %%i-cow
    fastboot delete-logical-partition %%i
    fastboot create-logical-partition %%i 1
)

echo ###############################
echo # FLASHING LOGICAL PARTITIONS #
echo ###############################
for %%i in (system system_ext product vendor vendor_dlkm odm vbmeta vbmeta_system vbmeta_vendor) do (
    fastboot flash %%i %%i.img
)

echo #############
echo # REBOOTING #
echo #############
choice /m "Reboot to system?"
if %errorlevel% equ 1 (
    fastboot reboot
)

pause