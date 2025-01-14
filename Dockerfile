FROM nvidia/cuda:11.8.0-cudnn8-devel-ubuntu22.04

ARG DEBIAN_FRONTEND=noninteractive
ARG TZ=UTC
ARG MINICONDA_VERSION=23.5.0-3
ARG PYTHON_VERSION=3.11

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get update
RUN apt install -y curl wget git ffmpeg
RUN curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash
RUN apt install git-lfs
RUN git lfs install

RUN adduser --disabled-password --gecos '' --shell /bin/bash user
USER user
ENV HOME=/home/user
WORKDIR $HOME
RUN mkdir $HOME/.cache $HOME/.config && chmod -R 777 $HOME
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-py311_$MINICONDA_VERSION-Linux-x86_64.sh
RUN ls -lah
RUN chmod +x ./Miniconda3-py311_$MINICONDA_VERSION-Linux-x86_64.sh
RUN ./Miniconda3-py311_$MINICONDA_VERSION-Linux-x86_64.sh -b -p /home/user/miniconda
ENV PATH="$HOME/miniconda/bin:$PATH"
RUN conda init
RUN conda install python=$PYTHON_VERSION
RUN python3 -m pip install --upgrade pip
RUN conda install pytorch==2.0.0 torchvision==0.15.0 torchaudio==2.0.0 pytorch-cuda=11.8 -c pytorch -c nvidia

# jupyter
RUN python3 -m pip install  install numba typing datasets>=2.6.1 git+https://github.com/huggingface/transformers@de9255de27abfcae4a1f816b904915f0b1e23cd9 git+https://github.com/huggingface/peft.git git+https://github.com/huggingface/accelerate.git gradio huggingface_hub librosa evaluate>=0.30 jiwer
WORKDIR /aicodebot
COPY . /aicodebot
RUN pip install -r requirements/requirements-dev.txt
RUN git config --global user.email "aicodebot@fakeemail.com"
RUN git config --global user.name "aicodebot"
WORKDIR /app
ENTRYPOINT ["python","-m", "aicodebot.cli"]
