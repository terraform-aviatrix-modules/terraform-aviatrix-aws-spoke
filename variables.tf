variable "spoke_name" {
  type = string
}

variable "region" {
  type = string
}

variable "cidr" {
  type = string
}

variable "aws_account_name" {
  type = string
}

variable "instance_size" {
  type    = string
  default = "t3.medium"
}

variable "ha_gw" {
  type    = bool
  default = true
}

variable "transit_gw" {
  type = string
}
