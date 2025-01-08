# Ragu Application Repository

This repository contains all components and setup instructions for the Ragu application stack. It includes:

- Ragu Chunker (`ragu-chunker`): Document processing and chunking service
- Ragu Web App (`ragu-web-app`): Frontend application for user interaction
- Ragu Chat API (`ragu-chat-api`): Backend API for chat functionality

# Docker
## chunker-api-local
prerequisite open-ai key
compatibility mode is required for arm64
compilation in linux compatibi  lity mode is hella slow
maybe we provide precompiled binaries?
api-local container will do the embeddings on your local machine which is slow
api-remote will do the embeddings on a remote machine which is fast if the machine has a GPU.
feserver is a service that provides embeddings for documents. It is used by chonkit to embed documents on a zverka.

## chat-api
gonna need a dockerfile for local and the docker file for gitlab deployment

are oauth things mandatory to run the app?

is vault necessary to run the app?

how about infobip?

~~i need docker to run the jooq generation, what can i do about that? i can run the thing on the host machine and then copy the generated files into the container
welp the database is running in the stack so i can utilize the db from the stack~~
seems to work fine actually now that i've setup everything

do we go like, hey the app is running and you can see it but can't do anything until you
get an opeanai key.

~~also, what do we do with the environment files, there must be a better way than i initially did
for onehub~~
~~the end goal is for someone to clone the repo press a button and the app is running
the configurations someone does should be trivial as well~~

**gonna solve this with mounting or env_files**

chat api is crashing will have to look into with the team

do we try to make a unified language for gradle.properties .env application.conf etc?

## vault
    # enabling this flag will make ragu-chat-api issue access tokens for ragu-chunker
    # vault connection is required for this feature