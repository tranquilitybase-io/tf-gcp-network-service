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
  project_id                             = var.project_id
  network_name                           = var.network_name
  routing_mode                           = var.routing_mode
  description                            = var.description
  shared_vpc_host                        = var.shared_vpc_host
  auto_create_subnetworks                = var.auto_create_subnetworks
  delete_default_internet_gateway_routes = var.delete_default_internet_gateway_routes
  mtu                                    = var.mtu
}

###
# Create subnets
###

module "subnets" {
  source           = "terraform-google-modules/network/google//modules/subnets"
  version          = "~> 3.0.0"
  project_id       = var.project_id
  network_name     = module.vpc.network_name
  subnets          = var.subnets
  secondary_ranges = var.secondary_ranges
}

###
# Create routes
###

module "routes" {
  source            = "terraform-google-modules/network/google//modules/routes"
  version           = "~> 3.0.0"
  project_id        = var.project_id
  network_name      = module.vpc.network_name
  routes            = var.routes
  module_depends_on = [module.subnets.subnets]
}

###
# Create firewall rules
###

module "firewall" {
  source              = "terraform-google-modules/network/google//modules/fabric-net-firewall"
  version             = "~> 3.0.0"
  project_id          = var.project_id
  network             = module.vpc.network_name
  http_source_ranges  = var.https_source_ranges
  http_target_tags    = var.https_target_tags
  https_source_ranges = var.https_source_ranges
  https_target_tags   = var.http_target_tags
  ssh_source_ranges   = var.ssh_source_ranges
  ssh_target_tags     = var.ssh_target_tags
  custom_rules        = var.firewall_custom_rules
}

###
# Create nat gw
###

module "cloud-nat" {
  source                             = "terraform-google-modules/cloud-nat/google"
  version                            = "~> 1.3.0"
  project_id                         = var.project_id
  region                             = var.region
  network                            = module.vpc.network_self_link
  create_router                      = var.create_router
  router                             = var.router_name
  name                               = var.router_nat_name
  nat_ip_allocate_option             = var.nat_ip_allocate_option
  nat_ips                            = var.nat_ips
  source_subnetwork_ip_ranges_to_nat = var.source_subnetwork_ip_ranges_to_nat
  log_config_enable                  = var.log_config_enable
  log_config_filter                  = var.log_config_filter
}