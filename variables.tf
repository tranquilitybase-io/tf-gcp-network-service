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

variable "region" {
  description = "The region to deploy to"
  type        = string
}

variable "project_id" {
  description = "Identifier of the host project where the VPC will be created"
  type        = string
}

variable "network_name" {
  description = "The name of the network being created"
  type        = string
}

variable "routing_mode" {
  description = "The network routing mode"
  type        = string
  default     = "REGIONAL"
}

variable "shared_vpc_host" {
  description = "Makes this project a Shared VPC host if 'true'"
  type        = bool
  default     = false
}

variable "auto_create_subnetworks" {
  description = "When set to true, the network is created in 'auto subnet mode' and it will create a subnet for each region automatically across the 10.128.0.0/9 address range. When set to false, the network is created in 'custom subnet mode' so the user can explicitly connect subnetwork resources"
  type        = bool
  default     = false
}

variable "delete_default_internet_gateway_routes" {
  description = "If set, ensure that all routes within the network specified whose names begin with 'default-route' and with a next hop of 'default-internet-gateway' are deleted"
  type        = bool
  default     = false
}

variable "description" {
  description = "An optional description of this resource. The resource must be recreated to modify this field"
  type        = string
  default     = ""
}

variable "mtu" {
  description = "The network MTU. Must be a value between 1460 and 1500 inclusive. If set to 0 (meaning MTU is unset), the network will default to 1460 automatically"
  type        = number
  default     = 0
}

variable "subnets" {
  description = "The list of subnets being created"
  type        = list(map(string))
}

variable "secondary_ranges" {
  description = "Secondary ranges that will be used in some of the subnets"
  type = map(list(object({
    range_name    = string
    ip_cidr_range = string
  })))
  default = {}
}

variable "routes" {
  description = "List of routes being created in this VPC"
  type        = list(map(string))
  default     = []
}

variable "firewall_custom_rules" {
  description = "List of custom rule definitions"
  type = map(object({
    description          = string
    direction            = string
    action               = string
    ranges               = list(string)
    sources              = list(string)
    targets              = list(string)
    use_service_accounts = bool
    rules = list(object({
      protocol = string
      ports    = list(string)
    }))
    extra_attributes = map(string)
  }))
  default = {
    allow-iap-ssh = {
      description          = "Allow inbound connections from Identity-Aware Proxy"
      direction            = "INGRESS"
      action               = "allow"
      ranges               = ["35.235.240.0/20"]
      use_service_accounts = false
      sources              = null
      targets              = ["allow-iap-ssh"]
      rules = [
        {
          protocol = "tcp"
          ports    = ["22"]
        }
      ]
      extra_attributes = {}
    }
  }
}

variable "ssh_source_ranges" {
  description = "List of IP CIDR ranges for tag-based SSH rule"
  type        = list(string)
  default     = []
}

variable "ssh_target_tags" {
  description = "List of target tags for tag-based SSH rule"
  default     = null
}

variable "http_source_ranges" {
  description = "List of IP CIDR ranges for tag-based HTTP rule"
  type        = list(string)
  default     = []
}

variable "http_target_tags" {
  description = "List of target tags for tag-based HTTP rule"
  default     = null
}

variable "https_source_ranges" {
  description = "List of IP CIDR ranges for tag-based HTTPS rule"
  type        = list(string)
  default     = []
}

variable "https_target_tags" {
  description = "List of target tags for tag-based HTTPS rule, defaults to https-server"
  type        = list(string)
  default     = null
}

variable "create_router" {
  description = "Create router instead of using an existing one, uses 'router' variable for new resource name"
  type        = bool
  default     = true
}

variable "router_name" {
  description = "Router name"
  type        = string
  default     = "cr-nat-router"
}

variable "router_nat_name" {
  description = "Name for the router NAT gateway"
  type        = string
  default     = "rn-nat-gateway"
}

variable "source_subnetwork_ip_ranges_to_nat" {
  description = "How NAT should be configured per Subnetwork"
  type        = string
  default     = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

variable "nat_ip_allocate_option" {
  description = "Value inferred based on nat_ips. If present set to MANUAL_ONLY, otherwise AUTO_ONLY"
  type        = string
  default     = "false"
}

variable "nat_ips" {
  description = "List of self_links of external IPs. Changing this forces a new NAT to be created"
  type        = list(string)
  default     = []
}

variable "log_config_enable" {
  description = "Indicates whether or not to export logs"
  type        = bool
  default     = true
}

variable "log_config_filter" {
  description = "Specifies the desired filtering of logs on this NAT. Valid values are: \"ERRORS_ONLY\", \"TRANSLATIONS_ONLY\", \"ALL\""
  type        = string
  default     = "ALL"
}

variable "create_dns_zone" {
  description = ""
  type = bool
  default = true
}

variable "dns_records" {
  description = "dns records to assign to zone"
  type = list(object({
    name = string
    type = string
    ttl  = number
    records = list(string)
  }))
  default = []
}

variable "network_visibility_domains" {
  description = ""
  type = list(string)
  default = []
}

variable "zone_domain" {
  description = ""
  type = string
  default = "example.com."
}

variable "zone_name" {
  description = ""
  type = string
  default = "example-com"
}

variable "zone_type" {
  description = ""
  type = string
  default = "private"
}
