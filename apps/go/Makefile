.PHONY: test vet lint fmt coverage check build run clean

test:
	go test -v ./...

vet:
	go vet ./...

lint:
	golangci-lint run

fmt:
	gofmt -w .

coverage:
	go test -coverprofile=coverage.out ./fizzbuzz
	go tool cover -func=coverage.out

check: fmt vet lint test

build:
	go build -o bin/fizzbuzz ./cmd/fizzbuzz

run:
	go run ./cmd/fizzbuzz

clean:
	go clean
	rm -rf bin/
	rm -f coverage.out coverage.html
