variable "vpc_name" {
  type    = string
  default = "kaz-vpc"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnet1_name" {
  type    = string
  default = "public-subnet-1"
}

variable "public_subnet1_cidr" {
  type    = string
  default = "10.0.1.0/24"
}

variable "public_subnet1_az" {
  type    = string
  default = "us-east-1a"
}

variable "public_subnet2_name" {
  type    = string
  default = "public-subnet-2"
}

variable "public_subnet2_cidr" {
  type    = string
  default = "10.0.2.0/24"
}

variable "public_subnet2_az" {
  type    = string
  default = "us-east-1b"
}

variable "private_subnet1_name" {
  type    = string
  default = "private-subnet-1"
}

variable "private_subnet1_cidr" {
  type    = string
  default = "10.0.3.0/24"
}

variable "private_subnet1_az" {
  type    = string
  default = "us-east-1c"
}

variable "private_subnet2_name" {
  type    = string
  default = "private-subnet-2"
}

variable "private_subnet2_cidr" {
  type    = string
  default = "10.0.4.0/24"
}

variable "private_subnet2_az" {
  type    = string
  default = "us-east-1d"
}

variable "igw_name" {
  type    = string
  default = "kaz-igw"
}

variable "nat_name" {
  type    = string
  default = "kaz-nat"
}

variable "public_rt_name" {
  type    = string
  default = "public-rt"
}

variable "private_rt_name" {
  type    = string
  default = "private-rt"
}