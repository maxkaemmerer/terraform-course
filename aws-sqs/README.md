## Setup Order

1. run `make prepare` - which installs terraform and creates a `variables.tf` file
2. fill in aws credentials and variables in `variables.tf`
3. run `make terraform` - which creates AWS infrastructure
3. run `make build` - which builds a docker image for the message producer
3. run `make run` - which writes a message into the queue