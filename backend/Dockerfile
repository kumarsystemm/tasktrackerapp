FROM golang:1.25-alpine AS builder

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o main ./cmd/main.go

FROM alpine:latest

RUN apk --no-cache add ca-certificates \
    && addgroup -S appgroup && adduser -S appuser -G appgroup

ENV GOMAXPROCS=2

WORKDIR /home/appuser/

COPY --from=builder /app/main .

RUN chown -R appuser:appgroup /home/appuser/

USER appuser

EXPOSE 8080

HEALTHCHECK --interval=10s --timeout=3s --start-period=5s --retries=3 \
    CMD wget -qO- http://localhost:8080/health || exit 1

STOPSIGNAL SIGINT

CMD ["./main"]
