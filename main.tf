# Copyright 2021 The Tranquility Base Authors
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

###
# Create vpc network
###

module "vpc" {
  source                                 = "terraform-google-modules/network/google//modules/vpc"
  version                                = "~> 3.0.0"
  auto_create_subnetworks                = var.auto_create_subnetworks
  delete_default_internet_gateway_routes = var.delete_default_internet_gateway_routes
  description                            = var.description
  mtu                                    = var.mtu
  network_name                           = var.network_name
  project_id                             = var.project_id
  routing_mode                           = var.routing_mode
  shared_vpc_host                        = var.shared_vpc_host
}

###
# Create subnets
###

module "subnets" {
  source           = "terraform-google-modules/network/google//modules/subnets"
  version          = "~> 3.0.0"
  network_name     = module.vpc.network_name
  project_id       = var.project_id
  secondary_ranges = var.secondary_ranges
  subnets          = var.subnets
}

###
# Create routes
###

module "routes" {
  source            = "terraform-google-modules/network/google//modules/routes"
  version           = "~> 3.0.0"
  module_depends_on = [module.subnets.subnets]
  network_name      = module.vpc.network_name
  project_id        = var.project_id
  routes            = var.routes
}

###
# Create firewall rules
###

module "firewall" {
  source              = "terraform-google-modules/network/google//modules/fabric-net-firewall"
  version             = "~> 3.0.0"
  custom_rules        = var.firewall_custom_rules
  http_source_ranges  = var.https_source_ranges
  http_target_tags    = var.https_target_tags
  https_source_ranges = var.https_source_ranges
  https_target_tags   = var.http_target_tags
  network             = module.vpc.network_name
  project_id          = var.project_id
  ssh_source_ranges   = var.ssh_source_ranges
  ssh_target_tags     = var.ssh_target_tags
}

###
# Create nat gw
###

module "cloud-nat" {
  source                             = "terraform-google-modules/cloud-nat/google"
  version                            = "~> 1.3.0"
  create_router                      = var.create_router
  log_config_enable                  = var.log_config_enable
  log_config_filter                  = var.log_config_filter
  name                               = var.router_nat_name
  nat_ip_allocate_option             = var.nat_ip_allocate_option
  nat_ips                            = var.nat_ips
  network                            = module.vpc.network_self_link
  project_id                         = var.project_id
  region                             = var.region
  router                             = var.router_name
  source_subnetwork_ip_ranges_to_nat = var.source_subnetwork_ip_ranges_to_nat
}

###
# Create dns zone and records
###

module "dns-private-zone" {
  source  = "terraform-google-modules/cloud-dns/google"
  version = "3.0.0"
  count   = var.create_dns_zone ? 1 : 0

  project_id                         = var.project_id
  type                               = var.zone_type
  name                               = var.zone_name
  domain                             = var.zone_domain
  private_visibility_config_networks = [module.vpc.network_self_link]
  recordsets                         = var.dns_records
}