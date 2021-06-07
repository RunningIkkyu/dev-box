FROM ubuntu:latest
RUN apt update \
    && DEBIAN_FRONTEND=noninteractive apt install -y \
        curl \
        exuberant-ctags \
        fish \
        fzf \
        git \
        less \
        ripgrep \
        unzip \
        wget \
        zsh \
    # --------------------------- Install tmux ------------------------------- 
    # ...
    # ---------------------------- Config tmux -------------------------------
    # ...
    # ---------------------------- Config zsh --------------------------------
    # ...
    # --------------------------- Install zsh --------------------------------
    # ...
    # --------------------------- Install neimvim ----------------------------
    && wget https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage \
    && chmod +x nvim.appimage && cp nvim.appimage /usr/bin/nvim \
    # --------------------------- Config neovim ------------------------------ 
    && mkdir -p $HOME/.local/share/nvim/site/pack/packer/start/ \
    && wget https://mirrors.ustc.edu.cn/golang/go1.16.linux-amd64.tar.gz  \
    && tar zxvf go1.16.linux-amd64.tar.gz  

# Install packer
RUN git clone https://github.com/wbthomason/packer.nvim \
        $HOME/.local/share/nvim/site/pack/packer/start/packer.nvim 

#RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true
RUN wget https://gitee.com/umico/ohmyzsh/raw/master/tools/install.sh -O - | zsh || true

RUN DEBIAN_FRONTEND=noninteractive apt install -y direnv

RUN cd $HOME \
    && mkdir -p $HOME/code/github \
    && cd $HOME/code/github \
    && git clone https://github.com/RunningIkkyu/dotfiles.git \
    && cd dotfiles  \
    && sh install.sh 

RUN DEBIAN_FRONTEND=noninteractive apt install -y gcc

# if the system cannot execute appimage, extract nvim from the image.
RUN mkdir -p $HOME/var \
    && cd $HOME/var \
    && nvim --appimage-extract \
    && cd squashfs-root/ \
    && mv AppRun nvim \
    && export PATH=$PATH:"`echo $PWD`" \
    && echo "export PATH=\$PATH:`echo $PWD`" >> $HOME/.zshrc \
    && rm /usr/bin/nvim

# Install plugin
RUN  cd $HOME/.config/nvim \
    && cp init.lua init.lua.bk \
    && export PATH=$PATH:"$HOME/var/squashfs-root/" \
    && echo "require 'plugins'" > init.lua \
    #&& nvim +"autocmd User PackerComplete quitall" +"PackerInstall" \
    && git config --global http.lowSpeedLimit 1000\
    && git config --global http.lowSpeedTime 30 \
    && nvim --headless +"lua require('packer').init({git={clone_timeout=240}})" \
                       +"autocmd User PackerComplete quitall" +PackerInstall \
    && mv init.lua.bk init.lua

