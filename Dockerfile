FROM deepnote/python:3.9

FROM debian: 10.7

ARG DEFAULT_TZ=America/Los_Angeles
ENV DEFAULT_TZ=$DEFAULT_TZ

RUN apt-get update \
   && DEBIAN_FRONTEND=noninteractive TZ=$DEFAULT_TZ apt-get install -y \
   tzdata \
   vim \
   nano \
   sudo \
   curl \
   wget \
   git && \
   rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://repo.anaconda.com/miniconda/$( wget -O - https://repo.anaconda.com/miniconda/ 2>/dev/null | grep -o 'Miniconda3-py38_[^"]*-Linux-x86_64.sh' | head -n 1) > /tmp/miniconda.sh \
       && chmod +x /tmp/miniconda.sh \
       && /tmp/miniconda.sh -b -p /opt/conda

ENV PATH=/opt/conda/bin:$PATH
RUN conda init

RUN pip install \
        jupyterlab \
        ipykernel \
        matplotlib \
        ipywidgets

ARG AUTH_KEY=5ca1ab1e
ENV AUTH_KEY=$AUTH_KEY

RUN curl https://get.modular.com | sh - && \
    modular auth $AUTH_Key
RUN modular install mojo

ARG MODULAR_HOME="/root/.modular"
ENV MODULAR_HOME=$MODULAR_HOME
ENV PATH="$PATH:$MODULAR_HOME/pkg/packages.modular.com_mojo/bin"

RUN chmod -R a+rwX /root
