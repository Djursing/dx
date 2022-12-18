FROM ubuntu:22.04

# envs
ENV DEFAULT_LANGUAGE=en_US
ENV DEFAULT_CHARSET=UTF-8
ENV DEFAULT_CHARSET_SHORT=utf8
ENV DEBIAN_FRONTEND=noninteractive

# core setup
RUN apt-get update \
	&& apt-get -y upgrade \
	&& apt-get -y install jq zsh vim neovim nano emacs git curl wget dnsutils coreutils grep gpg unzip less fonts-powerline locales apt-transport-https gnupg ca-certificates software-properties-common python3-pip \
	&& locale-gen en_US.UTF-8 \
	&& apt-get clean \
	&& apt-get autoclean \
	&& apt-get autoremove -y \
	&& rm -rf /var/lib/cache/* \
	&& rm -rf /var/lib/log/*

# tldr setup
RUN wget -qO /usr/local/bin/tldr https://gitlab.com/pepa65/tldr-bash-client/raw/master/tldr \
	&& chmod +x /usr/local/bin/tldr

# docker setup
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - \
	&& add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable" \
	&& apt-get update && apt-get -qq -y install docker-ce

# docker compose setup
RUN curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose \
	&& chmod +x /usr/local/bin/docker-compose

# oh my zsh setup
RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true
RUN chsh -s /bin/zsh $USER

# zsh config & theme
COPY .zshrc /root
COPY agnoster-mod.zsh-theme /root/.zsh/themes/agnoster-mod.zsh-theme

# stern
RUN wget https://github.com/wercker/stern/releases/download/1.11.0/stern_linux_amd64 \
	&& chmod +x ./stern_linux_amd64 \
	&& cp ./stern_linux_amd64 $HOME/bin/ster

ENTRYPOINT ["/bin/zsh"]



