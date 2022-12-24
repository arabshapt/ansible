ARG node_memory=8192
ARG user=arab
ARG UID=1000
FROM ubuntu:focal AS base
WORKDIR /usr/local/bin
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y software-properties-common curl git build-essential && \
    apt-add-repository -y ppa:ansible/ansible && \
    apt-get update && \
    apt-get install -y curl git ansible build-essential && \
    apt-get clean autoclean

RUN apt-get install -y sudo zip jq curl git

RUN adduser --disabled-password \
--gecos '' arab

#  Add new user arab to sudo group
RUN adduser arab sudo

# Ensure sudo group users are not 
# asked for a password when using 
# sudo command by ammending sudoers file
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> \
/etc/sudoers

# now we can set USER to the 
# user we just created
USER arab

FROM base AS arab
ARG TAGS
# RUN addgroup --gid 1000 arab
# RUN adduser --gecos arab --uid 1000 --gid 1000 --disabled-password arab
# RUN usermod -aG sudo arab
WORKDIR /home/arab

FROM arab
COPY . .
CMD ["sh", "-c", "ansible-playbook $TAGS fem.yml"]

