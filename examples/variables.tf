variable "content" {
  default = "My favorite pet is Mrs. Whiskers!"
}

variable "prefix" {
  default = ["Mrs", "Person", "Mr"]
  type = list(string)
}

variable "separator" {
  default = "."
}

variable "length" {
  default = 2
}

variable "file-content" {
  type = map
  default = {
    "statement1" = "We love pets!"
    "statement2" = "We love animals!"
  }
}