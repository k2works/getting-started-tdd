.PHONY: test vet lint coverage

test:
	go test ./...

vet:
	go vet ./...

lint:
	golangci-lint run

coverage:
	go test ./... -coverprofile=coverage.out
	go tool cover -func=coverage.out
