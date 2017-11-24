## About

Steam Link build of [*cool-retro-term*](https://github.com/Swordfish90/cool-retro-term), a terminal emulator which mimics the look and feel of the old cathode tube screens.

To compile, run "*build_steamlink.sh*" and when it's finished copy the "*steamlink*" folder to usb and reboot the Steam Link.

## Notes

If you run into compiling issues (mostly with unable to find Qt), you may have to compile Qt found in "*external/qt-everywhere-opensource-src-5.9.1*".  Run the "*build_steamlink.sh*" in there and it will build it... may take a while though.

Mouse use (right clicking for example) is broken and will probably cause the Steam Link to crash.

Turned off quite a few effects to try to make cool retro term run at a reasonable speed... If you wish to customize it either modify the settings in "*crt-src/app/qml/ApplicationSettings.qml*" or ssh into the Steam Link and modify the sqlite file located at "*/home/apps/crt/.home/.local/share/cool-retro-term/QML/OfflineStorage/Databases*".
