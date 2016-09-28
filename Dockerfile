FROM risdenk/r-base-docker

RUN apk add --no-cache ca-certificates wget build-base cmake boost-dev linux-pam-dev bash git && \
  update-ca-certificates

ENV RSTUDIO_VERSION 0.99.903

RUN wget -qO- https://github.com/rstudio/rstudio/archive/v${RSTUDIO_VERSION}.tar.gz | tar zx -C / && mv /rstudio-* /rstudio

RUN cd /rstudio/dependencies/common && \
  ./install-dictionaries && \
  ./install-mathjax && \
  ./install-pandoc && \
  ./install-packages

RUN mkdir -p /rstudio/build

WORKDIR /rstudio/build

#RUN cmake .. -DRSTUDIO_TARGET=Server -DCMAKE_BUILD_TYPE=RelMinSize

