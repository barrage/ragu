![Ragu Logo](logo.svg)

# Ragu Application Repository

Ragu is a system for creating and managing agents.

## Table of Contents

- [Components](#components)
- [Prerequisites](#prerequisites)
- [Getting Started](#getting-started)
  - [Clone](#clone)
  - [Configure](#configure)
  - [Start](#start)
- [Volumes](#volumes)
- [Notes](#notes)

## Components

- **Ragu Chunker (`ragu-chunker`):** Document processing and chunking service
  - [README](https://github.com/barrage/ragu-chunker/blob/main/README.md)
- **Ragu Web App (`ragu-web-app`):** Frontend application for user interaction
  - [README](https://github.com/barrage/ragu-web-app/blob/main/README.md)
- **Ragu Chat API (`ragu-chat-api`):** Backend API for chat functionality
  - [README](https://github.com/barrage/ragu-chat-api/blob/main/README.md)

This repository contains all components and setup instructions for the Ragu application stack.

## Prerequisites:

- **Git**
  - Git installation https://git-scm.com/book/en/v2/Getting-Started-Installing-Git
- **Docker**
  - Required version: 20.10.13 or higher
  - Docker installation https://docs.docker.com/desktop/
- **Docker Compose:**
  - Required version: 2.17.0 or higher
  - Docker Compose installation https://docs.docker.com/compose/install/
- **OpenAI API key**
  - OpenAI API key https://platform.openai.com/docs/overview

## Getting Started

### Clone

The repository contains submodules, so make sure to clone it with the `--recurse-submodules` flag.

Clone the repository with submodules

```bash
git clone --recurse-submodules https://github.com/barrage/ragu.git
```

Load submodules if you forgot to clone with `--recurse-submodules`

```bash
git submodule init && git submodule update
```

### Configure

This repository is configured to quickly set Ragu up with minimal configuration. As such, it only works with OpenAI as the model provider and requires no authorization to reduce the amount of starting configuration necessary when starting it. To change this, it is suggested to go through each of the applications' documentation page.

When the chat API runs without JWT authorization, any user that connects to it will "authorize" as the `admin` user, i.e. a dummy JWT is created for each request with the subject `admin` and the `admin` entitlement to allow the dummy user full access to the app.

---

**DISCLAIMER**: If running Ragu in production, an authorization server is mandatory to get the full feature set of the chat API.

---

An OpenAI API key is required to run the application.
Obtain this from OpenAI, then replace it in the following files:

- `config/ragu-chat-api/application.conf`

```kotlin
...
llm {
    openai {
      apiKey = "OPENAI_API_KEY"
    }
}
...
```

- `config/ragu-chunker/.env`

```env
...
OPENAI_KEY="OPENAI_API_KEY"
...
```

### Starting Ragu

### Un\*x systems

```bash
docker compose -f docker-compose-infra.yaml up -d
docker compose up -d
```

### Windows PowerShell

```bash
docker compose -f docker-compose-infra.yaml up -d;
docker compose up -d
```

First the infrastructure services are started which must be fully ready and accepting connections.

The infrastructure services are included in the main `docker-compose.yaml` file, therefore after the
initial setup the stack can be managed by it i.e. by just using the `docker compose` command.

Note, if the chunker will not start because it can't find the `ragu` bucket try restarting it.
If it still can't find it, re-run the `minio-createbucket` container and try it again.

_This process may take a while depending on your system, especially on ARM machines._

## Volumes

You can define volumes persist data on your host machine.

```yaml
# docker-compose-infra.yaml
volumes:
  postgres_data:
  qdrant_data:
  redis_data:
  minio_data:
  weaviate_data:
```

```yaml
# docker-compose.yaml
volumes:
  chonkit_data:
```

## Notes

Currently, the whole stack is built from source. In the future releases we will provide artifacts like
binaries, prebuilt images etc...
`ragu-chunker` is built in compatibility mode for arm64 systems which will cause slow compilation time on those systems.
