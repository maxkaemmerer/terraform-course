terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "> 1.3.0, != 1.4.0"
    }
  }
}

resource "random_pet" "my-pet" {
  length    = var.length
  prefix    = var.prefix[0]
  separator = var.separator
}

variable "filename" {
  default = [
    "pets.txt",
    "cats.txt",
  ]
}

resource "local_file" "pet" {
  filename        = "${path.module}/${each.value}"
  content         = "Pet Name: ${random_pet.my-pet.id}"
  file_permission = 0700

  for_each = toset(var.filename)

  depends_on = [
    random_pet.my-pet
  ]

  lifecycle {
    create_before_destroy = true
  }
}

data "local_file" "dogs" {
  filename = "${path.module}/dogs.txt"
}

output "pet-name" {
  value       = random_pet.my-pet.id
  description = "Record some value"
}

output "dogs-say" {
  value       = data.local_file.dogs.content
  description = "Record some value"
}
