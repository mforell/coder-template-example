
# See here for image contents: https://github.com/microsoft/vscode-dev-containers/tree/v0.194.0/containers/python-3/.devcontainer/base.Dockerfile

# [Choice] Python version: 3, 3.9, 3.8, 3.7, 3.6
#ARG VARIANT="3.9"
FROM tensorflow/tensorflow:latest-gpu-jupyter
RUN apt-get update && apt-get upgrade -y

RUN apt-get update && \
    DEBIAN_FRONTEND="noninteractive" apt-get install --yes \
    bash \
    build-essential \
    ca-certificates \
    curl \
    htop \
    locales \
    man \
    python3 \
    python3-pip \
    software-properties-common \
    sudo \
    systemd \
    systemd-sysv \
    unzip \
    vim \
    openssh-client \
    wget \
    ffmpeg && \
    # Install latest Git using their official PPA
    add-apt-repository ppa:git-core/ppa && \
    DEBIAN_FRONTEND="noninteractive" apt-get install --yes git
    


# RUN apt-get install python3-venv -y

# ENV VIRTUAL_ENV=/opt/venv
# RUN python -m venv $VIRTUAL_ENV
# ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# [Optional] If your pip requirements rarely change, uncomment this section to add them to the image.
COPY requirements.txt /tmp/pip-tmp/
RUN pip3 --disable-pip-version-check --no-cache-dir install -r /tmp/pip-tmp/requirements.txt \
   && rm -rf /tmp/pip-tmp
RUN pip install --upgrade pip
RUN pip install numpy --pre torch[dynamo] torchvision torchaudio --force-reinstall --extra-index-url https://download.pytorch.org/whl/nightly/cu117

RUN pip install streamlit

RUN useradd coder \
    --create-home \
    --shell=/bin/bash \
    --uid=1000 \
    --user-group && \
    echo "coder ALL=(ALL) NOPASSWD:ALL" >>/etc/sudoers.d/nopasswd

USER coder
ARG HOME=/home/coder
WORKDIR $HOME
COPY ./main.py $HOME/main.py
RUN export PATH="$HOME/.local/bin:$PATH"

RUN mkdir $HOME/.vscode && \
    echo '{ \
            "recommendations": [ \
                "github.copilot", \
                "ms-toolsai.jupyter", \
                "ms-python.python", \
                "ms-python.pylint", \
                "ms-python.vscode-pylance", \
                "ms-toolsai.jupyter-keymap" \
            ] \
        }' > $HOME/.vscode/extensions.json

# RUN sudo apt update && sudo apt install ffmpeg
