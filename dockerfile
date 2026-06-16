FROM codercom/code-server:latest

USER root

RUN apt-get update \
    && apt-get install -y --no-install-recommends curl ca-certificates git unzip \
    && rm -rf /var/lib/apt/lists/*

USER coder

# Download latest VSIX from your GitHub releases and install it
RUN mkdir -p /home/coder/demo \
    && curl -L -o /tmp/vscode-ifc.vsix \
       "https://marketplace.visualstudio.com/_apis/public/gallery/publishers/wolfnepomuk/vsextensions/vscode-ifc/latest/vspackage" \
    && code-server --install-extension /tmp/vscode-ifc.vsix \
    && rm /tmp/vscode-ifc.vsix

# Optional demo file
RUN cat > /home/coder/demo/example.ifc <<'EOF'
ISO-10303-21;
HEADER;
FILE_DESCRIPTION(('ViewDefinition [CoordinationView]'),'2;1');
FILE_NAME('demo.ifc','2026-06-16T00:00:00',('Demo'),('Demo'),'','','');
FILE_SCHEMA(('IFC4'));
ENDSEC;
DATA;
#1=IFCPERSON($,'Doe','John',$,$,$,$,$);
ENDSEC;
END-ISO-10303-21;
EOF

EXPOSE 8080

CMD ["code-server", "/home/coder/demo", "--bind-addr", "0.0.0.0:8080", "--auth", "password"]
