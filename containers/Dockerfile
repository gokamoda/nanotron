# Start with a minimal Ubuntu base image
FROM nvcr.io/nvidia/pytorch:24.11-py3

# Add the UV binary to the image
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# Set environment variables to avoid interaction during installation
ENV DEBIAN_FRONTEND=noninteractive

# Update package list and install essential utilities
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y --no-install-recommends\
    ca-certificates \
    zsh


RUN rm -rf /var/lib/apt/lists/*


# # zsh setup
ENV SHELL=/usr/bin/zsh
RUN chsh -s /usr/bin/zsh

# Add a non-root user with a home directory
# RUN groupadd -g $GID $USERNAME && \
#     useradd -m -u $UID -g $USERNAME -s /bin/bash $USERNAME

# Install starship
RUN curl -sS https://starship.rs/install.sh | sh --posix -s -- -y
RUN echo 'eval "$(starship init zsh)"' >> /root/.zshrc
COPY starship.toml /root/.config/starship.toml
RUN echo 'export STARSHIP_CONFIG="/root/.config/starship.toml"' >> /root/.zshrc

# Install zsh-autosuggestions
RUN mkdir -p /root/.zsh_plugins
RUN git clone https://github.com/zsh-users/zsh-autosuggestions /root/.zsh/zsh-autosuggestions
RUN echo 'source /root/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh' >> /root/.zshrc
RUN echo 'FPATH=/root/.zsh/zsh-autosuggestions:$FPATH' >> /root/.zshrc

# Install zsh-syntax-highlighting
RUN git clone https://github.com/zsh-users/zsh-syntax-highlighting.git /root/.zsh/zsh-syntax-highlighting
RUN echo 'source /root/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh' >> /root/.zshrc
RUN echo 'FPATH=/root/.zsh/zsh-syntax-highlighting:$FPATH' >> /root/.zshrc

# activate .venv automatically
RUN echo 'alias python="python3"' >> /root/.zshrc
RUN echo 'alias pip="pip3"' >> /root/.zshrc
RUN echo 'alias venv=". .venv/bin/activate"' >> /root/.zshrc
RUN echo 'venv' >> /root/.zshrc


# Set tini as the init system to handle zombie processes
WORKDIR /workspace

# Copy setup/create_env.sh and requirements.txt to the container
# COPY setup/create_env.sh /home/$USERNAME/project/setup/create_env.sh
# COPY requirements.txt /home/$USERNAME/project/requirements.txt
# # Run the setup script to create the virtual environment

# # RUN source /home/$USERNAME/project/setup/create_env.sh
RUN uv python install 3.11
RUN uv python pin 3.11

COPY pyproject.toml /workspace/pyproject.toml
COPY src /workspace/src
RUN uv sync --extra cu126 --no-dev
RUN uv sync --dev --no-build-isolation --extra cu126
RUN uv add git+https://github.com/fanshiqing/grouped_gemm@main --dev --no-build-isolation

# Run bash by default
CMD ["zsh"]