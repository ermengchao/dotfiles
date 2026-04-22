variable "region" {
  type    = string
  default = "ap-northeast-1"
}

variable "name" {
  type    = string
  default = "ec2-nixos"
}

variable "instance_type" {
  type    = string
  default = "t4g.nano"
}

variable "arch" {
  type    = string
  default = "arm64"
}

variable "nixos_version" {
  type    = string
  default = "25.11"
}

variable "key_name" {
  type    = string
  default = "ec2-nixos"
}

variable "root_volume_size" {
  type    = number
  default = 12
}
