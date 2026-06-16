FROM codercom/code-server:latest

USER root

RUN apt-get update \
    && apt-get install -y --no-install-recommends curl ca-certificates \
    && rm -rf /var/lib/apt/lists/*

USER coder

ARG VSCODE_IFC_VERSION=v0.3.2

RUN mkdir -p /home/coder/demo

RUN curl -L -o /tmp/vscode-ifc.vsix \
       "https://github.com/NepomukWolf/vscode-ifc/releases/download/${VSCODE_IFC_VERSION}/extension.vsix" \
    && code-server --install-extension /tmp/vscode-ifc.vsix \
    && rm /tmp/vscode-ifc.vsix

COPY --chown=coder:coder repo-files/ /home/coder/demo/

EXPOSE 8080

CMD ["code-server", "/home/coder/demo", "--bind-addr", "0.0.0.0:8080", "--auth", "password"]
