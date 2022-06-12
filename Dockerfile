FROM golang:1.18-alpine

# The latest alpine images don't have some tools like (`git` and `bash`).
# Adding git, bash and openssh to the image
RUN apk update && apk upgrade && \
    apk add --no-cache bash git openssh

RUN apt install protobuf-compiler
RUN apt install golang-goprotobuf-dev

WORKDIR /app

# Copy go mod and sum files
COPY go.mod ./

# Download all dependancies. Dependencies will be cached if the go.mod and go.sum files are not changed
RUN go mod download

# Copy the source from the current directory to the Working Directory inside the container
COPY . .

# If don't have deps in go.mod file:
#RUN go get -u github.com/golang/protobuf/{proto,protoc-gen-go}
#RUN go get -u google.golang.org/protobuf
#RUN echo 'export GOPATH=$HOME/Go' >> $HOME/.bashrc
#RUN source $HOME/.bashrc

# Build the Go app
RUN go build server.go

RUN ls -la

# Expose port 8080 to the outside world
EXPOSE 8080

# Run the executable
CMD ["./server"]
