FROM openjdk:8-jdk

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ed \
        less \
        locales \
        vim-tiny \
        wget \
        ca-certificates \
        fonts-texgyre \
    && rm -rf /var/lib/apt/lists/*

RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
    && locale-gen en_US.utf8 \
    && /usr/sbin/update-locale LANG=en_US.UTF-8

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8

ENV VER 1.0.31

RUN rm -rf /var/lib/apt/lists/ \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
    libssl1.0.0 \
    ca-certificates \
    file \
    git \
    libapparmor1 \
    libedit2 \
    libcurl4-openssl-dev \
    libssl-dev \
    lsb-release \
    psmisc \
    python-setuptools \
    sudo \
    r-base \
  && wget -q https://s3.amazonaws.com/rstudio-dailybuilds/rstudio-server-${VER}-amd64.deb \
  && dpkg -i rstudio-server-${VER}-amd64.deb \
  && rm rstudio-server-*-amd64.deb \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/

RUN useradd --create-home rstudio \
  && echo "rstudio:rstudio" | chpasswd

RUN echo 'options(repos = c(CRAN = "http://cran.rstudio.com/"))' >> /root/.Rprofile \
  && echo 'options(repos = c(CRAN = "http://cran.rstudio.com/"))' >> /rstudio/.Rprofile

ADD scripts /scripts

EXPOSE 8787

ENTRYPOINT /scripts/entrypoint.sh

