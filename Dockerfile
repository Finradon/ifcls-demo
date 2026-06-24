# syntax=docker/dockerfile:1.7
FROM ghcr.io/coder/code-server:4.123.0

ARG VSCODE_IFC_VERSION=v0.4.0
ARG VSCODE_IFC_SHA256=b67f9e931381369cff5bdd0652e872e3f3652260e3673975b146ac58ad1db726

ADD --checksum=sha256:${VSCODE_IFC_SHA256} --chown=coder:coder --chmod=0644 \
    https://github.com/NepomukWolf/vscode-ifc/releases/download/${VSCODE_IFC_VERSION}/extension.vsix \
    /tmp/vscode-ifc.vsix

USER coder

RUN mkdir -p /home/coder/.local/share/code-server/User \
    && code-server --install-extension /tmp/vscode-ifc.vsix \
    && rm /tmp/vscode-ifc.vsix

COPY --chown=coder:coder repo-files/.vscode/settings.json /home/coder/.local/share/code-server/User/settings.json
COPY --chown=coder:coder repo-files/ /home/coder/demo/

EXPOSE 8080

CMD ["code-server", "/home/coder/demo", "--bind-addr", "0.0.0.0:8080", "--auth", "password", "--disable-telemetry", "--disable-update-check", "--disable-proxy", "--disable-getting-started-override"]
