
variable "ami" {
    type = string
  default = "ami-02b64aa047cb5edf5"
}

variable "instance_type" {
    type = string
  default = "t2.micro"
}

variable "key_name" {
  type = string  
  default = "2026Keypair"
}
variable "security_group_id" {
  type = string
}

variable "instance_name" {
  type = string
  
}