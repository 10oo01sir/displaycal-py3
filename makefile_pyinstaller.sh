#!/bin/sh

build_displaycal()
{
	cp -rfp DisplayCAL/{lang,lib64,presets,ref,report,theme,ti1,x3d-viewer,xrc} temp/
	cp -rfp {scripts,screenshots,tests} temp/
	cp -rfp DisplayCAL/{*.wav,*.pem,*.fx,*.cal,*.ids} temp/
	cp -rfp {README*.html,LICENSE.txt,CHANGES.html} temp/
	# python setup_displaycal.py build_ext --inplace
	# rm -rf temp/* main/*
	# cp -rfp DisplayCAL/*.so temp/
	# cp -rfp PandaColor_Davinci_Draw_New_Figure.*.so temp/
	pyinstaller -Fw --clean --noconfirm -i DisplayCAL/theme/icons/DisplayCAL.icns main.py --add-data ./temp:DisplayCAL -n DisplayCAL
	pyinstaller -D --clean --noconfirm -i DisplayCAL/theme/icons/DisplayCAL.icns main.py --add-data ./temp:DisplayCAL -n DisplayCAL
	rm -rf temp/
}

mkdir -p temp/
mkdir -p build/
rm -rf build/*
rm -rf temp/*

if [ $1 == 'build' ];then
	build_displaycal
fi
