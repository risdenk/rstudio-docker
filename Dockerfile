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

ENV VER 1.1.456

RUN rm -rf /var/lib/apt/lists/ \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
    build-essential \
    ca-certificates \
    file \
    git \
    libapparmor1 \
    libbz2-dev \
    libcurl4-openssl-dev \
    libedit2 \
    liblzma-dev \
    libpcre3-dev \
    libssl-dev \
    libssl1.0.0 \
    lsb-release \
    psmisc \
    python-setuptools \
    sudo \
    r-base \
  && wget -q https://download1.rstudio.org/rstudio-${VER}-amd64.deb \
  && dpkg -i rstudio-server-${VER}-amd64.deb \
  && rm rstudio-server-*-amd64.deb \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/

RUN useradd --create-home rstudio \
  && echo "rstudio:rstudio" | chpasswd

RUN echo 'options(repos = c(CRAN = "http://cran.rstudio.com/"))' >> /root/.Rprofile \
  && echo 'options(repos = c(CRAN = "http://cran.rstudio.com/"))' >> /home/rstudio/.Rprofile

RUN echo "export LD_LIBRARY_PATH=/usr/lib/jvm/java-8-openjdk-amd64/lib/amd64:/usr/lib/jvm/java-8-openjdk-amd64/jre/lib/amd64/server" >> /root/.profile \
  && echo "export LD_LIBRARY_PATH=/usr/lib/jvm/java-8-openjdk-amd64/lib/amd64:/usr/lib/jvm/java-8-openjdk-amd64/jre/lib/amd64/server" >> /home/rstudio/.profile

RUN R CMD javareconf

RUN wget -qO- https://github.com/just-containers/s6-overlay/releases/download/v1.11.0.1/s6-overlay-amd64.tar.gz | tar xz -C /

COPY run.sh /etc/services.d/rstudio/run

EXPOSE 8787

ENTRYPOINT ["/init"]

