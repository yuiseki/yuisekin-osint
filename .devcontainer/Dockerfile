FROM ubuntu:22.04

RUN apt update && apt install -y \
    git \
    curl \
    vim \
    htop \
    jq \
    gcc \
    make

RUN curl -Ls https://deb.nodesource.com/setup_18.x | bash
RUN apt update && apt install -y nodejs

RUN useradd -m user

ENV RUST_VERSION stable
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain ${RUST_VERSION}
RUN echo 'source /home/user/.cargo/env' >> /home/user/.bashrc
ENV PATH="/home/user/.cargo/bin:${PATH}"

RUN rustup install stable
RUN rustup component add rls rust-analysis
RUN cargo install htmlq

CMD [ "sleep", "infinity" ]
