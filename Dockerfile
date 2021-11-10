FROM ubuntu:latest

RUN apt update \
    && DEBIAN_FRONTEND=noninteractive apt install -y \
        curl \
        #exuberant-ctags \
        fish \
        git \
        less \
        ripgrep \
        unzip \
        wget \
        zsh \
        g++ \
        direnv \
        sudo

# Config git, speed up git clone in China
RUN git config --global http.sslVerify false && \
    git config --global url."https://hub.fastgit.org".insteadOf "https://github.com"

# oh-my-zsh
#RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true
RUN wget https://hub.fastgit.org/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true

# Install fzf, after oh-my-zsh
RUN git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
# Replace "github.com" to "hub.fastgit.org" in ~/fzf/install
RUN sed -i 's/github.com/hub.fastgit.org/g' ~/.fzf/install
RUN ~/.fzf/install --all

# Install nvim
# if the system cannot execute appimage, extract nvim from the image.
RUN mkdir -p $HOME/var && cd $HOME/var && \
    wget https://download.fastgit.org/neovim/neovim/releases/download/nightly/nvim.appimage && \
    chmod +x nvim.appimage && \
    ./nvim.appimage --appimage-extract &&  \
    cd squashfs-root && \
    cp AppRun nvim  && \
    cd /usr/bin && \
    ln -s /root/var/squashfs-root/nvim nvim

# Personal Configs
RUN mkdir -p $HOME/code/github.com/RunningIkkyu 
RUN cd $HOME/code/github.com/RunningIkkyu && \
    git clone https://github.com/RunningIkkyu/dotfiles.git && \
    $HOME/code/github.com/RunningIkkyu/dotfiles/config.sh && echo "1"

# Remove colorscheme
RUN sed -i '$s/^\(.\)/--\1/g' $HOME/.config/nvim/init.lua


RUN nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
# Install and Compile
#COPY install.sh /root/install.sh
#RUN chmod +x /root/install.sh

# Add colorscheme back
RUN sed -i '$s/^--\(.\)/\1/g' $HOME/.config/nvim/init.lua

# Replace "[[ gruvbox]]" to "-- [[ gruvbox]]"
RUN sed -i '$s/^\[\[ gruvbox\]\]/-- \[\[ gruvbox\]\]/g' $HOME/.config/nvim/init.lua

# Remove lines containing "--"
RUN sed -i '/--/d' $HOME/.config/nvim/init.lua

#3RUN wget https://mirrors.ustc.edu.cn/golang/go1.17.linux-amd64.tar.gz  \
#    tar zxvf go1.17.linux-amd64.tar.gz  

# 
# RUN mkdir -p $HOME/.config/nvim && cp $HOME/code/github/dotfiles/nvim_0.5_vim_plug/init.vim  $HOME/.config/nvim/init.vim
# ENV PATH=$PATH:"/root/var/squashfs-root/"
# 
# 
# #RUN nvim -E -s -u "~/.config/nvim/init.vim" +PlugInstall +qall
# RUN nvim +PlugInstall +qall
# RUN cp $HOME/code/github/dotfiles/nvim_0.5_vim_plug/init.vim.bk  $HOME/.config/nvim/init.vim
# 

WORKDIR /root
