variable "name" {
  description = "Name for this spoke VPC and it's gateways"
  type        = string
}

variable "prefix" {
  description = "Boolean to determine if name will be prepended with avx-"
  type        = bool
  default     = true
}

variable "suffix" {
  description = "Boolean to determine if name will be appended with -spoke"
  type        = bool
  default     = true
}

variable "region" {
  description = "The AWS region to deploy this module in"
  type        = string
}

variable "cidr" {
  description = "The CIDR range to be used for the VPC"
  type        = string
}

variable "account" {
  description = "The AWS account name, as known by the Aviatrix controller"
  type        = string
}

variable "instance_size" {
  description = "AWS Instance size for the Aviatrix gateways"
  type        = string
  default     = "t3.medium"
}

variable "ha_gw" {
  description = "Boolean to determine if module will be deployed in HA or single mode"
  type        = bool
  default     = true
}

variable "insane_mode" {
  description = "Set to true to enable Aviatrix high performance encryption."
  type        = bool
  default     = false
}

variable "az1" {
  description = "Concatenates with region to form az names. e.g. eu-central-1a. Only used for insane mode"
  type        = string
  default     = "a"
}

variable "az2" {
  description = "Concatenates with region to form az names. e.g. eu-central-1b. Only used for insane mode"
  type        = string
  default     = "b"
}

variable "transit_gw" {
  description = "Name of the transit gateway to attach this spoke to"
  type        = string
}

variable "active_mesh" {
  description = "Set to false to disable active mesh."
  type        = bool
  default     = true
}

locals {
  lower_name        = replace(lower(var.name), " ", "-")
  prefix            = var.prefix ? "avx-" : ""
  suffix            = var.suffix ? "-spoke" : ""
  name              = "${local.prefix}${local.lower_name}${local.suffix}"
  subnet            = var.insane_mode ? cidrsubnets(var.cidr, 3)[length(cidrsubnets(var.cidr, 3))] : aviatrix_vpc.default.subnets[length(aviatrix_vpc.default.subnets) / 2].cidr
  ha_subnet         = var.insane_mode ? cidrsubnets(var.cidr, 3)[length(cidrsubnets(var.cidr, 3))] : aviatrix_vpc.default.subnets[length(aviatrix_vpc.default.subnets) / 2 + 1].cidr
  insane_mode_az    = var.insane_mode ? "${var.region}${var.az1}" : null
  ha_insane_mode_az = var.insane_mode ? "${var.region}${var.az2}" : null
}