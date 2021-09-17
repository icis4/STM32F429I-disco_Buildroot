url_buildroot = https://git.buildroot.net/buildroot
archive_buildroot = buildroot.tar.gz
system_image = stm32f769i-disco_system.uImage
dir_download = downloads
dir_configs = configs
dir_buildroot = buildroot

bootstrap:
	git clone $(url_buildroot)
	#git pull
	make -C $(dir_buildroot) stm32f429_disco_defconfig
	#cp $(dir_configs)/buildroot $(dir_buildroot)/.config

build:
	make -j10 -C $(dir_buildroot)

flash:
	cd $(dir_buildroot)/output/build/host-openocd-0.10.0/tcl && ../../../host/usr/bin/openocd \
	-f board/stm32f429discovery.cfg \
	-c "init" \
	-c "reset init" \
	-c "flash probe 0" \
	-c "flash info 0" \
	-c "flash write_image erase ../../../images/stm32f429i-disco.bin 0x08000000" \
	-c "flash write_image erase ../../../images/stm32f429-disco.dtb 0x08004000" \
	-c "flash write_image erase ../../../images/xipImage 0x08008000" \
	-c "reset run" -c shutdown

clean:
	rm -rf $(dir_buildroot) $(dir_download)
