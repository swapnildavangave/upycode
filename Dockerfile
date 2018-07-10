FROM ubuntu:18.04
RUN echo 'Acquire::HTTP::Proxy "http://172.17.0.1:3142";' >> /etc/apt/apt.conf.d/01proxy \
    && echo 'Acquire::HTTPS::Proxy "false";' >> /etc/apt/apt.conf.d/01proxy

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y software-properties-common \
wget curl ca-certificates gpg clang cmake \
sudo git python3 python3-pip python3-dev build-essential libyaml-dev

RUN apt-get install -y libavcodec-dev libavformat-dev libavutil-dev \
libavresample-dev python-dev libsamplerate0-dev \
libtag1-dev libchromaprint-dev python3-six python3-tk \
libasound2 libgtk2.0-0 libxext-dev libxrender-dev libxslt1.1 \
libnotify4 libnspr4 libnss3 libxtst-dev  libxss1 libxkbfile1

#Installing VSCode ...
WORKDIR /usr/share/fonts
RUN git clone --depth 1 https://github.com/tonsky/FiraCode.git
WORKDIR /usr/share/fonts/FiraCode
RUN git filter-branch --subdirectory-filter distr && fc-cache -f -v \
    && apt-get -y install build-essential

WORKDIR /tmp

RUN curl http://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg \
    && mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg \
    && sh -c 'echo "deb [arch=amd64] http://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list' \
    && apt-get update \
    && apt-get -y install code
ENV PIP_INDEX_URL=http://172.17.0.1:4000/simple/
ENV PIP_TRUSTED_HOST=172.17.0.1
ADD ./requirements.txt /tmp/requirements.txt
RUN cd /tmp \
    && pip3 install -r requirements.txt
RUN apt-get install -y gdebi-core \
    && wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
    && echo "y\n" | gdebi google-chrome-stable_current_amd64.deb

# Building Alias
ENV EXT_HOME=/usr/share/extensions
RUN mkdir -p $EXT_HOME \
    && chmod 777 $EXT_HOME \
    && printf '#!/usr/bin/env bash\ncode  --extensionHomePath=$EXT_HOME "$@"' > /usr/bin/ide && chmod a+x /usr/bin/ide
ENV LANG C.UTF-8
RUN ide --user-data-dir=/usr/share/extensions --install-extension AlanWalk.markdown-toc \
    && ide --user-data-dir=/usr/share/extensions --install-extension DavidAnson.vscode-markdownlint \
    && ide --user-data-dir=/usr/share/extensions --install-extension IBM.output-colorizer \
    && ide --user-data-dir=/usr/share/extensions --install-extension JulioGold.vscode-smart-split-into-lines \
    && ide --user-data-dir=/usr/share/extensions --install-extension Shan.code-settings-sync \
    && ide --user-data-dir=/usr/share/extensions --install-extension ZakCodes.includecompletion \
    && ide --user-data-dir=/usr/share/extensions --install-extension aaron-bond.better-comments \
    && ide --user-data-dir=/usr/share/extensions --install-extension alefragnani.project-manager \
    && ide --user-data-dir=/usr/share/extensions --install-extension bajdzis.vscode-database \
    && ide --user-data-dir=/usr/share/extensions --install-extension bbenoist.Doxygen \
    && ide --user-data-dir=/usr/share/extensions --install-extension bibhasdn.django-html \
    && ide --user-data-dir=/usr/share/extensions --install-extension bibhasdn.django-snippets \
    && ide --user-data-dir=/usr/share/extensions --install-extension bibhasdn.unique-lines \
    && ide --user-data-dir=/usr/share/extensions --install-extension bigous.vscode-multi-line-tricks \
    && ide --user-data-dir=/usr/share/extensions --install-extension christian-kohler.path-intellisense \
    && ide --user-data-dir=/usr/share/extensions --install-extension davilink.join-lines-into-columns \
    && ide --user-data-dir=/usr/share/extensions --install-extension doi.fileheadercomment \
    && ide --user-data-dir=/usr/share/extensions --install-extension donjayamanne.githistory \
    && ide --user-data-dir=/usr/share/extensions --install-extension donjayamanne.python-extension-pack \
    && ide --user-data-dir=/usr/share/extensions --install-extension eamodio.gitlens \
    && ide --user-data-dir=/usr/share/extensions --install-extension edwardhjp.vscode-author-generator \
    && ide --user-data-dir=/usr/share/extensions --install-extension felipecaputo.git-project-manager \
    && ide --user-data-dir=/usr/share/extensions --install-extension jasonn-porch.gitlab-mr \
    && ide --user-data-dir=/usr/share/extensions --install-extension magicstack.MagicPython \
    && ide --user-data-dir=/usr/share/extensions --install-extension mitaki28.vscode-clang \
    && ide --user-data-dir=/usr/share/extensions --install-extension ms-python.python \
    && ide --user-data-dir=/usr/share/extensions --install-extension njpwerner.autodocstring \
    && ide --user-data-dir=/usr/share/extensions --install-extension robertohuertasm.vscode-icons \
    && ide --user-data-dir=/usr/share/extensions --install-extension ted-996.python-editing-terminal \
    && ide --user-data-dir=/usr/share/extensions --install-extension tht13.python \
    && ide --user-data-dir=/usr/share/extensions --install-extension tushortz.python-extended-snippets \ 
    && ide --user-data-dir=/usr/share/extensions --install-extension twxs.cmake \
    && ide --user-data-dir=/usr/share/extensions --install-extension vector-of-bool.cmake-tools \
    && ide --user-data-dir=/usr/share/extensions --install-extension wholroyd.jinja

RUN apt-get clean -qq -y \
    && apt-get autoclean -qq -y \
    && apt-get autoremove -qq -y \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/*
ADD ./init.sh /bin/onInit
RUN chmod a+x /bin/onInit
CMD [ "onInit" ]