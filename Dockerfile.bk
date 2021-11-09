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
        gcc \
        direnv \
    # --------------------------- Install tmux ------------------------------- 
    # ...
    # ---------------------------- Config tmux -------------------------------
    # ...
    # --------------------------- Install zsh --------------------------------
    # ...
    # --------------------------- Install neimvim ----------------------------
    # --------------------------- Install golang ------------------------------ 
    && wget https://mirrors.ustc.edu.cn/golang/go1.16.linux-amd64.tar.gz  \
    && tar zxvf go1.16.linux-amd64.tar.gz  


RUN cd $HOME \
    && mkdir -p $HOME/code/github \
    && git config --global http.sslVerify false \
    && cd $HOME/code/github \
    && git clone https://github.com/RunningIkkyu/dotfiles.git
 
# Install plug.vim
RUN sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://gitee.com/cyemeng/vim-plug/raw/master/plug.vim'

#RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true
RUN wget https://gitee.com/umico/ohmyzsh/raw/master/tools/install.sh -O - | zsh || true

# if the system cannot execute appimage, extract nvim from the image.
RUN mkdir -p $HOME/var && cd $HOME/var \
    && wget https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage \
    && chmod +x nvim.appimage && cp nvim.appimage /usr/bin/nvim \
    && cd $HOME/var \
    && nvim --appimage-extract \
    && cd squashfs-root/ \
    && mv AppRun nvim \
    && export PATH=$PATH:"`echo $PWD`"  \
    && echo "export PATH=\$PATH:`echo $PWD`" >> $HOME/.zshrc \
    && rm /usr/bin/nvim


RUN mkdir -p $HOME/.config/nvim && cp $HOME/code/github/dotfiles/nvim_0.5_vim_plug/init.vim  $HOME/.config/nvim/init.vim
ENV PATH=$PATH:"/root/var/squashfs-root/"


#RUN nvim -E -s -u "~/.config/nvim/init.vim" +PlugInstall +qall
RUN nvim +PlugInstall +qall
RUN cp $HOME/code/github/dotfiles/nvim_0.5_vim_plug/init.vim.bk  $HOME/.config/nvim/init.vim

WORKDIR /root
