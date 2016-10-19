#!/bin/sh
set -e

#ln -sf /etc/X11/xinit/xinput.d/ibus.conf /root/.xinputrc
#ln -sf /etc/X11/xinit/xinput.d/ibus.conf /home/user/.xinputrc

user="toybox"
#group="toybox"

#if [ -n "${TOYBOX_GID}" ] && ! cat /etc/group | awk 'BEGIN{ FS= ":" }{ print $3 }' | grep ${TOYBOX_GID} > /dev/null 2>&1; then
#    groupmod -g ${TOYBOX_GID} ${group}
#    echo "GID of ${group} has been changed."
#fi

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

exec $@
