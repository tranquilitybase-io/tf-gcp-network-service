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
  description = "GCP region name"
  type        = string
  default     = "europe-west2"
}

variable "project_id" {
  description = "Identifier for the host project to be created"
  type        = string
}

variable "network_name" {
  description = "The name of the network being created"
  type        = string
  default     = "vpc-network"
}

variable "subnets" {
  description = "The list of subnets being created"
  type        = list(map(string))
  default = [
    {
      subnet_name               = "shared-network-snet"
      subnet_ip                 = "10.0.0.0/24"
      subnet_region             = "europe-west2"
      subnet_private_access     = "true"
      subnet_flow_logs          = "true"
      subnet_flow_logs_interval = "INTERVAL_10_MIN"
      subnet_flow_logs_sampling = 0.7
      subnet_flow_logs_metadata = "INCLUDE_ALL_METADATA"
    },
    {
      subnet_name               = "shared-ec-snet"
      subnet_ip                 = "10.0.1.0/24"
      subnet_region             = "europe-west2"
      subnet_private_access     = "true"
      subnet_flow_logs          = "true"
      subnet_flow_logs_interval = "INTERVAL_10_MIN"
      subnet_flow_logs_sampling = 0.7
      subnet_flow_logs_metadata = "INCLUDE_ALL_METADATA"
    },
    {
      subnet_name               = "shared-itsm-snet"
      subnet_ip                 = "10.0.2.0/24"
      subnet_region             = "europe-west2"
      subnet_private_access     = "true"
      subnet_flow_logs          = "true"
      subnet_flow_logs_interval = "INTERVAL_10_MIN"
      subnet_flow_logs_sampling = 0.7
      subnet_flow_logs_metadata = "INCLUDE_ALL_METADATA"
    },
    {
      subnet_name               = "activator-project-snet"
      subnet_ip                 = "10.0.4.0/24"
      subnet_region             = "europe-west2"
      subnet_private_access     = "true"
      subnet_flow_logs          = "true"
      subnet_flow_logs_interval = "INTERVAL_10_MIN"
      subnet_flow_logs_sampling = 0.7
      subnet_flow_logs_metadata = "INCLUDE_ALL_METADATA"
    },
    {
      subnet_name               = "workspace-project-snet"
      subnet_ip                 = "10.0.5.0/24"
      subnet_region             = "europe-west2"
      subnet_private_access     = "true"
      subnet_flow_logs          = "true"
      subnet_flow_logs_interval = "INTERVAL_10_MIN"
      subnet_flow_logs_sampling = 0.7
      subnet_flow_logs_metadata = "INCLUDE_ALL_METADATA"
    },
    {
      subnet_name               = "shared-bastion"
      subnet_ip                 = "10.0.6.0/24"
      subnet_region             = "europe-west2"
      subnet_private_access     = "true"
      subnet_flow_logs          = "true"
      subnet_flow_logs_interval = "INTERVAL_10_MIN"
      subnet_flow_logs_sampling = 0.7
      subnet_flow_logs_metadata = "INCLUDE_ALL_METADATA"
    }
  ]
}

variable "secondary_ranges" {
  description = "Secondary ranges that will be used in some of the subnets"
  type = map(list(object({
    range_name    = string
    ip_cidr_range = string
  })))
  default = {
    shared-ec-snet = [
      {
        range_name    = "gke-pods-snet"
        ip_cidr_range = "10.1.0.0/17"
      },
    ]
    shared-ec-snet = [
      {
        range_name    = "gke-services-snet"
        ip_cidr_range = "10.1.128.0/20"
      },
    ]
    shared-itsm-snet = [
      {
        range_name    = "gke-pods-snet"
        ip_cidr_range = "10.2.0.0/17"
      },
    ]
    shared-itsm-snet = [
      {
        range_name    = "gke-services-snet"
        ip_cidr_range = "10.2.128.0/20"
      },
    ]
    activator-project-snet = [
      {
        range_name    = "gke-pods-snet"
        ip_cidr_range = "10.4.0.0/17"
      },
    ]
    activator-project-snet = [
      {
        range_name    = "gke-services-snet"
        ip_cidr_range = "10.4.128.0/20"
      },
    ]
    workspace-project-snet = [
      {
        range_name    = "gke-pods-snet"
        ip_cidr_range = "10.5.0.0/17"
      },
    ]
    workspace-project-snet = [
      {
        range_name    = "gke-services-snet"
        ip_cidr_range = "10.5.128.0/20"
      },
    ]
  }
}

variable "firewall_custom_rules" {
  description = "List of custom rule definitions"
  type = map(object({
    description          = string
    direction            = string
    action               = string # (allow|deny)
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
    allow-iap-ingress = {
      description          = "Allow inbound connections from Identity-Aware Proxy"
      direction            = "INGRESS"
      action               = "allow"
      ranges               = ["35.235.240.0/20"]
      use_service_accounts = false
      sources              = null
      targets              = null
      rules = [
        {
          protocol = "tcp"
          ports    = []
        }
      ]
      extra_attributes = {}
    }
  }
}