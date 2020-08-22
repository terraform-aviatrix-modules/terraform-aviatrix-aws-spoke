variable "name" {
  type = string
}

variable "region" {
  type = string
}

variable "cidr" {
  type = string
}

variable "account" {
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

variable "insane_mode" {
  type    = bool
  default = false
}

variable "az1" {
  type    = string
  default = "a"
}

variable "az2" {
  type    = string
  default = "b"
}

variable "transit_gw" {
  type = string
}
