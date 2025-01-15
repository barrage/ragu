![Ragu Logo](logo.svg)

# Ragu Application Repository
Ragu is a system for creating and managing agents.

It includes:
- Ragu Chunker (`ragu-chunker`): Document processing and chunking service
  - [README](ragu-chunker/README.md)
- Ragu Web App (`ragu-web-app`): Frontend application for user interaction
  - [README](ragu-web-app/README.md)
- Ragu Chat API (`ragu-chat-api`): Backend API for chat functionality
  - [README](ragu-chat-api/README.md)

This repository contains all components and setup instructions for the Ragu application stack.

# Prerequisites:
- Git
  - Git installation https://git-scm.com/book/en/v2/Getting-Started-Installing-Git
- Docker
  - Required version: 20.10.13 or higher
  - Docker installation https://docs.docker.com/desktop/
- Docker Compose:
  - Required version: 2.17.0 or higher
  - Docker Compose installation https://docs.docker.com/compose/install/
- OpenAI API key
  - OpenAI API key https://platform.openai.com/docs/overview
- Google Oauth2 client id and secret
  - Google Oauth2 https://developers.google.com/identity/protocols/oauth2

# Getting Started
This chapter will cover steps to start the Ragu application stack on your local machine utilizing OpenAI for embeddings 
and llms and Google as Oauth provider.

Supported providers:

| Oauth  | LLM                            | Embedder                                       |
|--------|--------------------------------|------------------------------------------------|
| Google | OpenAI                         | OpenAI                                         |
| Apple  | Azure                          | Azure                                          |
| Carnet | Ollama (for local development) | Onnx Compatible models (for local development) |

This article will cover cloud based solution with OpenAI and Azure. Local development guide will be provided 
in the future releases.
## Clone the repository
```bash
git clone git@github.com:barrage/ragu.git
cd ragu
```

## Configure the environment
Minimal requirements are an Oauth provider and OpenAI API key.
### Oauth configuration
Having an Oauth2 client id and secret is required to run the application. Obtain these from Google or Apple or Carnet.
For example, if we want to enable Google Oauth, edit the following files:
- `config/ragu-chat-api/application.conf`
```kotlin
...
features {
    ...
    oauth {
        google = true
    }
    ...
}
...
oauth {
    google {
      tokenEndpoint = "tokenEndpoint"
      keysEndpoint = "keysEndpoint"
      tokenIssuer = "tokenIssuer"
      accountEndpoint = "accountEndpoint"
      clientId = "clientId"
      clientSecret = "clientSecret"
    }
}
...
```
- `config/ragu-web-app/.env`
```env
...
OAUTH_GOOGLE_LOGIN_CLIENTID=google-client-id
...
```
The rest of the stack is configured to work together but feel free to make changes that suit your needs.
And/or vendors.

### OpenAI configuration
An OpenAI API key is required to run the application. Obtain this from OpenAI.
Edit the following files:
- `config/ragu-chat-api/application.conf`
```kotlin
...
llm {
    openai {
      endpoint = "https://api.openai.com/v1/"
      apiKey = "apiKey"
    }
}
...
```
- `config/ragu-chunker/.env`
```env
...
OPENAI_KEY="open-ai-key"
...
```
## Give permission to install script
### Un*x based systems
```bash
chmod 700 install.sh
```
### Windows
Batch scripts are executable by default on Windows.

## Run the install script
The script will initialize the submodules, build the docker images, start the services and prompt you to create the
initial admin account.
### Un*x based systems
```bash
./install.sh
```
### Windows
```bash
./install.bat
```
When the script finishes you can manage the stack using `docker compose`.

## Volumes
You can define volumes in the `docker-compose.yml` file to persist data on your host machine.
```yaml
volumes:
  postgres_data:
  qdrant_data:
  chonkit_data:
  weaviate_data:
  feserver_data:
```
 ## Notes
Currently, the whole stack is built from source. In the future releases we will provide artifacts like 
binaries, prebuilt images etc...
`ragu-chunkger` is built in compatibility mode for arm64 systems which will cause slow compilation time on those systems.



