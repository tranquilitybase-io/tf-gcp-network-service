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
    }
  ]
}