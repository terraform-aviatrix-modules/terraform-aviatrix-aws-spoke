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

# Single Transit GW
resource "aviatrix_spoke_gateway" "single" {
  count              = var.ha_gw ? 0 : 1
  enable_active_mesh = var.active_mesh
  cloud_type         = 1
  vpc_reg            = var.region
  gw_name            = local.name
  gw_size            = var.instance_size
  vpc_id             = aviatrix_vpc.default.vpc_id
  account_name       = var.account
  subnet             = local.subnet
  insane_mode        = var.insane_mode
  insane_mode_az     = local.insane_mode_az
  transit_gw         = var.transit_gw
}

# HA Transit GW
resource "aviatrix_spoke_gateway" "ha" {
  count              = var.ha_gw ? 1 : 0
  enable_active_mesh = var.active_mesh
  cloud_type         = 1
  vpc_reg            = var.region
  gw_name            = local.name
  gw_size            = var.instance_size
  vpc_id             = aviatrix_vpc.default.vpc_id
  account_name       = var.account
  subnet             = local.subnet
  ha_subnet          = local.ha_subnet
  ha_gw_size         = var.instance_size
  insane_mode        = var.insane_mode
  insane_mode_az     = local.insane_mode_az
  ha_insane_mode_az  = local.ha_insane_mode_az
  transit_gw         = var.transit_gw
}
