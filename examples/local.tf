
resource random_pet "my-pet" {
  length = var.length
  prefix = var.prefix[0]
  separator = var.separator
}

resource local_file "pet" {
  filename             = "${path.module}/pets.txt"
  content              = "Pet Name: ${random_pet.my-pet.id}"
  file_permission      = 0700

  depends_on = [
    random_pet.my-pet
  ]
}

output "pet-name" {
  value = random_pet.my-pet.id
  description = "Record some value"
}