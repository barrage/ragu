ARG ONX_VERSION=1.20.1
ARG PDFIUM_VERSION=6996

FROM rust:latest AS builder

ARG ONX_VERSION
ARG PDFIUM_VERSION
ARG FEATURES="weaviate openai gdrive"

WORKDIR /app

COPY chonkit ./chonkit
COPY chunx ./chunx
COPY embedders ./embedders
COPY .sqlx ./chonkit/.sqlx

RUN mkdir pdfium && curl -sL https://github.com/bblanchon/pdfium-binaries/releases/download/chromium%2F${PDFIUM_VERSION}/pdfium-linux-x64.tgz | tar -xzf - -C ./pdfium
RUN mkdir onnxruntime && curl -sL https://github.com/microsoft/onnxruntime/releases/download/v${ONX_VERSION}/onnxruntime-linux-x64-${ONX_VERSION}.tgz | tar -xzf - -C ./onnxruntime

WORKDIR /app/chonkit

RUN echo "Building with: ${FEATURES}"
RUN cargo build --no-default-features -F "${FEATURES}" --release --target-dir ./target

FROM debian:latest

ARG ONX_VERSION

WORKDIR /app

# Create upload directories
RUN mkdir data

COPY --from=builder /app/chonkit/target/release/chonkit ./chonkit
COPY --from=builder /app/chonkit/migrations ./migrations
COPY --from=builder /app/pdfium/lib/libpdfium.so /usr/lib
COPY --from=builder /app/onnxruntime/onnxruntime-linux-x64-${ONX_VERSION}/lib/libonnxruntime.so /usr/lib

RUN apt-get update 

RUN apt-get install -y ca-certificates 
RUN apt-get install -y libssl3 

RUN update-ca-certificates 

RUN apt clean 

EXPOSE 42069

ENTRYPOINT ["./chonkit"]
