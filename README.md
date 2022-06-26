# Terraform Cours Notes

* `terraform init` initializes terraform files and downloads the providers required by the configuration files in the current directory
* `terraform plan` shows us what the changes made will be when we `apply` the current config, `terraform plan -out some-plan` creates plan file that can be applied and that prevents changes that happen between `plan`and `apply` to be applied.
* `terraform apply` applies the changes required by to move from the current state to the state described in the config files


## Variables
Variables can be created in multiple ways, if multiple sources are present the the power one was precedence.
1. cli arguments `terraform apply -var "filename=/order/fourth.txt"`
2. variable.auto.tfvars `filename = "/order/third.txt"`, any file with the pattern `*.auto.tfvars` in alphabetical order
3. terraform.tfvars `filename = "/order/second.txt"`
4. Environment variables `export T_VAR_filename = "/order/first.txt"`

If the variable does not have a default value you will be prompted for it. Adding the sensitive=true flag to the variable ensures that the entered input is not visible.


## Digital Ocean
Get Images
````shell
curl -X GET \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $DIGITALOCEAN_TOKEN" \
  "https://api.digitalocean.com/v2/images?page=1&per_page=1000"
````

Get Droplet Sizes
````shell
curl -X GET \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $DIGITALOCEAN_TOKEN" \
  "https://api.digitalocean.com/v2/sizes" 
````