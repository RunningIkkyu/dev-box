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

RUN rm /bin/nvim \
    && mkdir -p $HOME/var \
    && cd $HOME/var \
    &&nvim --appimage-extract \
    && cd squashfs-root/ \
    && mv AppRun nvim \
    && echo "export PATH=\$PATH:`echo $PWD`" >> ~/.zshrc

