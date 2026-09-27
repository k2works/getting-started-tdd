export LANG := C.UTF-8
export LC_ALL := C.UTF-8

.PHONY: test vet lint fmt check

test:
	go test -v ./...

vet:
	go vet ./...

lint:
	golangci-lint run

fmt:
	gofmt -l -w .

check: fmt vet lint test
