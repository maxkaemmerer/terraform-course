## Setup Order

An AWS account as well as an AWS IAM user with access key is required and needs to be creates in advance. The IAM user needs SQS and IAM permissions so make sure to add the corresponding policies when creating the user. (https://docs.aws.amazon.com/IAM/latest/UserGuide/id_users_create.html)

1. run `make prepare` - which installs terraform and creates a `variables.tf` file
2. fill in aws credentials and variables in `variables.tf`
3. run `make terraform` - which creates AWS infrastructure
3. run `make build` - which builds a docker image for the message producer
3. run `make run` - which writes a message into the queue