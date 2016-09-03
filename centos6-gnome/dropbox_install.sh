

# Install Dropbox - https://www.dropbox.com/ja/install?os=linux
cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf - \
    && ~/.dropbox-dist/dropboxd \
    && mkdir -p ~/bin && cd ~/bin && wget "https://www.dropbox.com/download?dl=packages/dropbox.py" \
    && chmod 755 ~/bin/dropbox.py
