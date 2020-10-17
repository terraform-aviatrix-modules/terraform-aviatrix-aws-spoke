# Aviatrix Spoke VPC
resource "aviatrix_vpc" "default" {
  cloud_type           = 1
  region               = var.region
  cidr                 = var.cidr
  account_name         = var.account
  name                 = local.name
  aviatrix_transit_vpc = false
  aviatrix_firenet_vpc = false
}
#Spoke GW
resource "aviatrix_spoke_gateway" "default" {
  enable_active_mesh = var.active_mesh
  cloud_type         = 1
  vpc_reg            = var.region
  gw_name            = local.name
  gw_size            = var.instance_size
  vpc_id             = aviatrix_vpc.default.vpc_id
  account_name       = var.account
  subnet             = local.subnet
  ha_subnet          = var.ha_gw ? local.ha_subnet : null
  ha_gw_size         = var.ha_gw ? var.instance_size : null
  insane_mode        = var.insane_mode
  insane_mode_az     = local.insane_mode_az
  ha_insane_mode_az  = var.ha_gw ? local.ha_insane_mode_az : null
  transit_gw         = var.transit_gw
}