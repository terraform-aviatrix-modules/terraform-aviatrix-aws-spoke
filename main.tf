# Aviatrix Spoke VPC
resource "aviatrix_vpc" "default" {
  count                = length(var.existing_vpc_id) > 0 ? 0 : 1
  cloud_type           = 1
  region               = var.region
  cidr                 = var.cidr
  account_name         = var.account
  name                 = local.name
  aviatrix_transit_vpc = false
  aviatrix_firenet_vpc = false
  num_of_subnet_pairs  = var.vpc_subnet_pairs
  subnet_size          = var.vpc_subnet_size
}
#Spoke GW
resource "aviatrix_spoke_gateway" "default" {
  enable_active_mesh                    = var.active_mesh
  cloud_type                            = 1
  vpc_reg                               = var.region
  gw_name                               = local.name
  gw_size                               = var.instance_size
  vpc_id                                = length(var.existing_vpc_id) > 0 ? var.existing_vpc_id : aviatrix_vpc.default[0].vpc_id
  account_name                          = var.account
  subnet                                = length(var.existing_vpc_id) > 0 ? var.subnet1_cidr : local.subnet
  ha_subnet                             = var.ha_gw ? (length(var.existing_vpc_id) > 0 ? local.subnet2_cidr : local.ha_subnet) : null
  ha_gw_size                            = var.ha_gw ? var.instance_size : null
  insane_mode                           = var.insane_mode
  insane_mode_az                        = local.insane_mode_az
  ha_insane_mode_az                     = var.ha_gw ? local.ha_insane_mode_az : null
  manage_transit_gateway_attachment     = false
  single_az_ha                          = var.single_az_ha
  single_ip_snat                        = var.single_ip_snat
  customized_spoke_vpc_routes           = var.customized_spoke_vpc_routes
  filtered_spoke_vpc_routes             = var.filtered_spoke_vpc_routes
  included_advertised_spoke_routes      = var.included_advertised_spoke_routes
  enable_encrypt_volume                 = var.enable_encrypt_volume
  customer_managed_keys                 = var.customer_managed_keys
  enable_private_vpc_default_route      = var.private_vpc_default_route
  enable_skip_public_route_table_update = var.skip_public_route_table_update
  enable_auto_advertise_s2c_cidrs       = var.auto_advertise_s2c_cidrs
  tunnel_detection_time                 = var.tunnel_detection_time
  tags                                  = var.tags
}

resource "aviatrix_spoke_transit_attachment" "default" {
  count           = var.attached ? 1 : 0
  spoke_gw_name   = aviatrix_spoke_gateway.default.gw_name
  transit_gw_name = var.transit_gw
}

resource "aviatrix_segmentation_security_domain_association" "default" {
  count                = var.attached ? (length(var.security_domain) > 0 ? 1 : 0) : 0 #Only create resource when attached and security_domain is set.
  transit_gateway_name = var.transit_gw
  security_domain_name = var.security_domain
  attachment_name      = aviatrix_spoke_gateway.default.gw_name
  depends_on           = [aviatrix_spoke_transit_attachment.default] #Let's make sure this cannot create a race condition
}
