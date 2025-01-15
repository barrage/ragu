![Ragu Logo](logo.svg)

# Ragu Application Repository
Ragu is a system for creating and managing agents.

It includes:
- Ragu Chunker (`ragu-chunker`): Document processing and chunking service
  - [README](https://github.com/barrage/ragu-chunker/blob/main/README.md)
- Ragu Web App (`ragu-web-app`): Frontend application for user interaction
  - [README](https://github.com/barrage/ragu-web-app/blob/main/README.md)
- Ragu Chat API (`ragu-chat-api`): Backend API for chat functionality
  - [README](https://github.com/barrage/ragu-chat-api/blob/main/README.md)

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

Detailed Oauth information can be found in `ragu-chat-api` documentation [Authentication Chapter](https://github.com/barrage/ragu-chat-api?tab=readme-ov-file#authentication)

Supported providers:

| Oauth  | LLM                            | Embedder                                       |
|--------|--------------------------------|------------------------------------------------|
| Google | OpenAI                         | OpenAI                                         |
| Apple  | Azure                          | Azure                                          |
| Carnet | Ollama (for local development) | Onnx Compatible models (for local development) |

This article will cover cloud based solution with OpenAI and Azure. Local development guide will be provided 
in the future releases.
## Clone the repository
The repository contains submodules, so make sure to clone it with the `--recurse-submodules` flag.
### Clone the repository with submodules
```bash
git clone --recurse-submodules git@github.com:barrage/ragu.git
```
### Load submodules if you forgot to clone with `--recurse-submodules`
```bash
git submodule init && \
git submodule update
```


## Configure the environment
Minimal requirements are an Oauth provider and OpenAI API key.
### Oauth configuration
Having an Oauth2 client id and secret is required to run the application. Obtain these from Google or Apple or Carnet.
For example, if we want to enable Google Oauth and create, edit the following files:
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
// use this to create the initial admin account
// be careful to use the email of your Oauth provider account
admin {
  email = "admin.admin@admin.com"
  fullName = "Admin"
  firstName = "Admin"
  lastName = "Admin"
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



