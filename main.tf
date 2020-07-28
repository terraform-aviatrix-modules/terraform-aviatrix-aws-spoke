# Aviatrix Spoke VPC
resource "aviatrix_vpc" "default" {
  cloud_type           = 1
  region               = var.region
  cidr                 = var.cidr
  account_name         = var.aws_account_name
  name                 = "spoke-vpc-${var.spoke_name}"
  aviatrix_transit_vpc = false
  aviatrix_firenet_vpc = false
}

# Single Transit GW
resource "aviatrix_spoke_gateway" "single" {
  count              = var.ha_gw ? 0 : 1
  enable_active_mesh = true
  cloud_type         = 1
  vpc_reg            = var.region
  gw_name            = "spoke-${var.region}-${var.spoke_name}"
  gw_size            = var.instance_size
  vpc_id             = aviatrix_vpc.default.vpc_id
  account_name       = var.aws_account_name
  subnet             = aviatrix_vpc.default.subnets[length(aviatrix_vpc.default.subnets)/2].cidr
  transit_gw         = var.transit_gw
}

# HA Transit GW
resource "aviatrix_spoke_gateway" "ha" {
  count              = var.ha_gw ? 1 : 0
  enable_active_mesh = true
  cloud_type         = 1
  vpc_reg            = var.region
  gw_name            = "spoke-${var.region}-${var.spoke_name}"
  gw_size            = var.instance_size
  vpc_id             = aviatrix_vpc.default.vpc_id
  account_name       = var.aws_account_name
  subnet             = aviatrix_vpc.default.subnets[length(aviatrix_vpc.default.subnets)/2].cidr
  ha_subnet          = aviatrix_vpc.default.subnets[length(aviatrix_vpc.default.subnets)/2+1].cidr
  ha_gw_size         = var.instance_size
  transit_gw         = var.transit_gw
}
