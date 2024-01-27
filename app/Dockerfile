FROM rust:1.73 as builder
WORKDIR /app
RUN rustup target add x86_64-unknown-linux-musl
RUN apt update && apt install -y musl-tools musl-dev
COPY ./src ./src
COPY ./Cargo* .
RUN cargo build --target x86_64-unknown-linux-musl --release

FROM alpine:3
WORKDIR /app
COPY --from=builder /app/target/x86_64-unknown-linux-musl/release/app ./sysinfo
EXPOSE 8080

ENTRYPOINT ["./sysinfo"]
