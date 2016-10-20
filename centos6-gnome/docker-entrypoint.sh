#!/bin/sh
set -e

user="toybox"
if [ -n "${TOYBOX_UID}" ] && ! cat /etc/passwd | awk 'BEGIN{ FS= ":" }{ print $3 }' | grep ${TOYBOX_UID} > /dev/null 2>&1; then
    usermod -u ${TOYBOX_UID} ${user}
    echo "UID of ${user} has been changed."
fi

[ "${JAPANESE_SUPPORT}" = "yes" ] && {
    echo "Japanese support enabled."

    # locale
    localedef -f UTF-8 -i /usr/share/i18n/locales/ja_JP ja_JP.UTF-8
    sed -i -e "s/LANG=\"en_US.UTF-8\"/LANG=\"ja_JP.UTF-8\"/" /etc/sysconfig/i18n
    echo "SUPPORTED=\"en_US.UTF-8:en_US:en:ja_JP.UTF-8:ja_JP:ja\"" >> /etc/sysconfig/i18n

    # Timezone
    yes | cp /usr/share/zoneinfo/Japan /etc/localtime
    sed -i -e "s:ZONE=\"Etc/UTC\":ZONE=\"Asia/Tokyo\":" /etc/sysconfig/clock

    # enable DBUS for IME
    dbus-uuidgen > /var/lib/dbus/machine-id

    # enable IME & IME settings
    ln -sf /etc/X11/xinit/xinput.d/ibus.conf /root/.xinputrc \
    && ln -sf /etc/X11/xinit/xinput.d/ibus.conf /home/toybox/.xinputrc

    # IME settings
    gconftool-2 --direct --config-source xml:readwrite:/etc/gconf/gconf.xml.mandatory \
     	--type bool --set /desktop/gnome/interface/show_input_method_menu true \
    && gconftool-2 --direct --config-source xml:readwrite:/etc/gconf/gconf.xml.mandatory \
     	--type list --list-type string --set /desktop/ibus/general/preload_engines ["anthy"] \
    && gconftool-2 --direct --config-source xml:readwrite:/etc/gconf/gconf.xml.mandatory \
     	--type bool --set /desktop/ibus/general/use_global_engine true \
    && gconftool-2 --direct --config-source xml:readwrite:/etc/gconf/gconf.xml.mandatory \
     	--type bool --set /desktop/ibus/panel/show_im_name true \
    && gconftool-2 --direct --config-source xml:readwrite:/etc/gconf/gconf.xml.mandatory \
        --type bool --set /desktop/ibus/panel/use_custom_font true \
    && gconftool-2 --direct --config-source xml:readwrite:/etc/gconf/gconf.xml.mandatory \
    	    --type string --set /desktop/ibus/panel/custom_font "IPAPGothic 12"

    # Folder settings( xdg-user-dirs )
    sed -i -e "/### END INIT INFO/a\sudo -u toybox LC_ALL=en_US xdg-user-dirs-update --force" /etc/init.d/vncserver
    sed -i -e "/### END INIT INFO/a\LC_ALL=en_US xdg-user-dirs-update --force" /etc/init.d/vncserver
    sed -i -e "/### END INIT INFO/a\sed -i -e \"s\/enabled=False\/enabled=True\/\" \/etc\/xdg\/user-dirs.conf" /etc/init.d/vncserver
}

# application installer

mkdir -p /installer
apps=(
    LibreOffice
    dropbox
    evolution
    firefox
    gedit
    general_purpose_desktop
    gimp
    gthumb
    LibreOffice
    nano
    nautilus-open-terminal
    network_utilities
    samba_client
    sublime_text_3
    system_utilities
    totem
    utilities
    vim
)

for app in ${apps[@]}; do
    printf "create installer of the ${app} at /installer/${app}.sh ..."

    yum="yum update -y && yum install -y"
    yum_group="yum update -y && yum groupinstall -y"
    func=""

    if [ "${app}" = "LibreOffice" ]; then
        func="${yum} libreoffice"
        [ "${JAPANESE_SUPPORT}" = "yes" ] && {
            func="${func} libreoffice-langpack-ja"
        }

    elif [ "${app}" = "dropbox" ]; then
        func=$(cat << EOF
if ! which wget; then
        yum update -y && yum install -y wget
    fi
    cd ${HOME}
    wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
    ${HOME}/.dropbox-dist/dropboxd &
    mkdir -p ${HOME}/bin
    wget "https://www.dropbox.com/download?dl=packages/dropbox.py" -O /usr/local/bin/dropbox
    chmod 755 /usr/local/bin/dropbox
EOF
)
    elif [ "${app}" = "general_purpose_desktop" ]; then
        func="${yum_group} 'General Purpose Desktop'"

    elif [ "${app}" = "network_utilities" ]; then
        func="${yum} curl wget"

    elif [ "${app}" = "samba_client" ]; then
        func="${yum} samba-client samba-common"

    elif [ "${app}" = "sublime_text_3" ]; then
        func=$(cat << EOF
if ! which wget; then
        yum update -y && yum install -y wget
    fi
    wget https://download.sublimetext.com/sublime_text_3_build_3126_x64.tar.bz2 -O ~/Downloads/sublime.tar.bz2
    tar jxvf ~/Downloads/sublime.tar.bz2 -C /opt
    rm -rf ~/Downloads/sublime.tar.bz2
    ln -sf /opt/sublime_text_3/sublime_text.desktop /usr/share/applications/
    sed -i \
        -e 's:Icon=sublime-text:Icon=/opt/sublime_text_3/Icon/48x48/sublime-text.png:' \
        -e 's:/opt/sublime_text/:/opt/sublime_text_3/:g' \
        /opt/sublime_text_3/sublime_text.desktop
EOF
)
    elif [ "${app}" = "system_utilities" ]; then
        func="${yum} htop dstat gnome-utils gnome-system-monitor system-config-language gconf-editor"

    elif [ "${app}" = "utilities" ]; then
        func="${yum} file-roller unzip"

    else
        func="${yum} ${app}"
    fi
    cat << EOF > /installer/${app}.sh
#!/bin/bash
set -e

_install() {
    ${func}
    echo "complete!"
}

_install

exit 0
EOF
    chmod 755 /installer/${app}.sh
    echo "done."
done

# temp
echo "alias la='ls -la'" >> /root/.bashrc
echo "alias la='ls -la'" >> /home/toybox/.bashrc

exec $@
