AGENTS.md

Repository Purpose

This repository defines a temporary, publicly accessible code-server demo instance for the VS Code extension:

wolfnepomuk.vscode-ifc

The goal is to provide a simple browser-based VS Code environment where visitors can try the extension without installing anything locally.

The instance is intended for short-lived demo use, for example for award submissions, evaluation links, or public showcase purposes.

Expected Deployment Model

The repository is designed to be deployed as a Docker-based web service, preferably on a simple hosting provider such as Render.

The container should:

* run code-server
* expose it on port 8080
* bind to 0.0.0.0
* use password authentication
* preload the IFC extension
* optionally open a demo workspace containing example files

Security Assumptions

This is a public demo environment, not a production development environment.

Do not place secrets, private source code, private IFC files, credentials, API keys, SSH keys, tokens, or other sensitive data in this repository or in the deployed container image.

Password protection is intended only as lightweight access control for the demo.

The deployed instance should be treated as disposable.

Required Environment Variables

The deployment must provide the following environment variable:

PASSWORD=<demo-password>

code-server uses this variable for password authentication when started with:

code-server --auth password

Do not hard-code the password in the Dockerfile, scripts, or committed configuration files.

Dockerfile Guidelines

When editing the Dockerfile:

* use the official codercom/code-server image unless there is a strong reason not to
* keep the image small and simple
* install only packages needed for the demo
* avoid long-running setup logic at container startup
* prefer doing extension installation during image build
* pin extension versions when demo reproducibility matters
* expose port 8080

The preferred command shape is:

code-server /home/coder/demo --bind-addr 0.0.0.0:8080 --auth password

Extension Installation

The IFC extension should be preinstalled into the image.

Preferred installation method:

1. Download the .vsix package during the Docker build.
2. Install it with:

code-server --install-extension /path/to/extension.vsix

3. Remove the temporary .vsix file afterwards.

If possible, pin the extension to a known-good release asset from GitHub rather than relying on a moving latest endpoint.

Example pattern:

RUN curl -L -o /tmp/vscode-ifc.vsix \
    "https://github.com/NepomukWolf/vscode-ifc/releases/download/<VERSION>/<FILE>.vsix" \
    && code-server --install-extension /tmp/vscode-ifc.vsix \
    && rm /tmp/vscode-ifc.vsix

Using a pinned release makes the public demo more reliable and easier to reproduce.

Demo Workspace

The default workspace should live at:

/home/coder/demo

It may contain small example files that help users immediately test the extension.

Keep demo files:

* small
* public
* non-sensitive
* easy to understand
* directly relevant to IFC extension functionality

Avoid committing large IFC models unless they are explicitly intended for public distribution.

Hosting Notes

For Render-style deployment, a render.yaml may define a Docker web service.

Example:

services:
  - type: web
    name: vscode-ifc-demo
    runtime: docker
    plan: free
    envVars:
      - key: PASSWORD
        sync: false

The password should be configured in the hosting provider dashboard, not in the repository.

Expected Public Behavior

A user opening the deployed URL should see the code-server login page.

After entering the demo password, the user should arrive in a VS Code-like browser environment with the IFC extension already installed.

The demo should not require users to:

* create an account
* install VS Code
* install the extension manually
* clone the repository
* configure the language server manually, unless this is unavoidable for the extension itself

Maintenance Rules

When making changes:

* keep the setup boring and reproducible
* avoid adding unnecessary orchestration
* avoid adding databases or persistent storage unless absolutely needed
* avoid provider-specific complexity where a plain Dockerfile is enough
* document any required manual deployment step in the README
* test the container locally before relying on the hosted deployment

A useful local test command is:

docker build -t vscode-ifc-demo .
docker run --rm -p 8080:8080 -e PASSWORD=demo vscode-ifc-demo

Then open:

http://localhost:8080

README Expectations

The README should explain:

* what the demo is
* how to deploy it
* how to set the PASSWORD environment variable
* how to run it locally
* which extension version is installed
* whether the instance is temporary
* any known limitations of the hosted environment

Do Not Add

Do not add:

* real credentials
* personal access tokens
* private SSH keys
* private IFC files
* university-internal files
* production source code
* persistent user storage
* unnecessary reverse proxy configuration
* complex CI/CD unless needed

Agent Guidance

When modifying this repository, prioritize simplicity over completeness.

This repository is not meant to become a general-purpose cloud IDE platform. It is a minimal, disposable demo wrapper around code-server and the IFC extension.

Before adding complexity, ask whether the change directly improves the public demo experience.
