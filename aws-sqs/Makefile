install-deps:
	curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
	sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $$(lsb_release -cs) main"
	sudo apt-get update && sudo apt-get install terraform

prepare: install-deps
	cp variables.tf.dist variables.tf

terraform:
	terraform init
	terraform apply

build:
	docker build -t produce .

run:
	docker run produce

destroy:
	terraform destroy