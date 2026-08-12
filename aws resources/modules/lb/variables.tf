variable "alb_name" {
  type    = string
  default = "kaz-alb"
}

variable "vpc_id" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "security_group_id" {
  type = string
}

variable "target_instance_id" {
  type = string
}