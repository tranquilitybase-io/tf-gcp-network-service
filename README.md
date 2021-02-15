# tf-gcp-network-service

## Module overview

Terraform module for creating networking resources on Google Cloud Platform (GCP).

It deploys the following resources into a given GCP project:

- VPC network
- Subnets
- Cloud NAT
- Network Firewall 
- Routes (optional)

## Usage

Refer to the examples under [examples/](examples) directory.

## Requirements

| Name | Version |
|------|---------|
| terraform | >=0.14.2,<0.15 |
| google | <4.0,>= 2.12 |

## Providers

| Name | Version |
|------|---------|
| google | <4.0,>= 2.12 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| auto\_create\_subnetworks | When set to true, the network is created in 'auto subnet mode' and it will create a subnet for each region automatically across the 10.128.0.0/9 address range. When set to false, the network is created in 'custom subnet mode' so the user can explicitly connect subnetwork resources | `bool` | `false` | no |
| create\_router | Create router instead of using an existing one, uses 'router' variable for new resource name | `bool` | `true` | no |
| delete\_default\_internet\_gateway\_routes | If set, ensure that all routes within the network specified whose names begin with 'default-route' and with a next hop of 'default-internet-gateway' are deleted | `bool` | `false` | no |
| description | An optional description of this resource. The resource must be recreated to modify this field | `string` | `""` | no |
| firewall\_custom\_rules | List of custom rule definitions | <pre>map(object({<br>    description          = string<br>    direction            = string<br>    action               = string<br>    ranges               = list(string)<br>    sources              = list(string)<br>    targets              = list(string)<br>    use_service_accounts = bool<br>    rules = list(object({<br>      protocol = string<br>      ports    = list(string)<br>    }))<br>    extra_attributes = map(string)<br>  }))</pre> | <pre>{<br>  "allow-iap-ingress": {<br>    "action": "allow",<br>    "description": "Allow inbound connections from Identity-Aware Proxy",<br>    "direction": "INGRESS",<br>    "extra_attributes": {},<br>    "ranges": [<br>      "35.235.240.0/20"<br>    ],<br>    "rules": [<br>      {<br>        "ports": [],<br>        "protocol": "tcp"<br>      }<br>    ],<br>    "sources": null,<br>    "targets": null,<br>    "use_service_accounts": false<br>  }<br>}</pre> | no |
| http\_source\_ranges | List of IP CIDR ranges for tag-based HTTP rule | `list(string)` | `[]` | no |
| http\_target\_tags | List of target tags for tag-based HTTP rule | `any` | `null` | no |
| https\_source\_ranges | List of IP CIDR ranges for tag-based HTTPS rule | `list(string)` | `[]` | no |
| https\_target\_tags | List of target tags for tag-based HTTPS rule, defaults to https-server | `list(string)` | `null` | no |
| log\_config\_enable | Indicates whether or not to export logs | `bool` | `true` | no |
| log\_config\_filter | Specifies the desired filtering of logs on this NAT. Valid values are: "ERRORS\_ONLY", "TRANSLATIONS\_ONLY", "ALL" | `string` | `"ALL"` | no |
| mtu | The network MTU. Must be a value between 1460 and 1500 inclusive. If set to 0 (meaning MTU is unset), the network will default to 1460 automatically | `number` | `0` | no |
| nat\_ip\_allocate\_option | Value inferred based on nat\_ips. If present set to MANUAL\_ONLY, otherwise AUTO\_ONLY | `string` | `"false"` | no |
| nat\_ips | List of self\_links of external IPs. Changing this forces a new NAT to be created | `list(string)` | `[]` | no |
| network\_name | The name of the network being created | `string` | n/a | yes |
| project\_id | Identifier of the host project where the VPC will be created | `string` | n/a | yes |
| region | The region to deploy to | `string` | n/a | yes |
| router\_name | Router name | `string` | `"cr-nat-router"` | no |
| router\_nat\_name | Name for the router NAT gateway | `string` | `"rn-nat-gateway"` | no |
| routes | List of routes being created in this VPC | `list(map(string))` | `[]` | no |
| routing\_mode | The network routing mode | `string` | `"REGIONAL"` | no |
| secondary\_ranges | Secondary ranges that will be used in some of the subnets | <pre>map(list(object({<br>    range_name    = string<br>    ip_cidr_range = string<br>  })))</pre> | `{}` | no |
| shared\_vpc\_host | Makes this project a Shared VPC host if 'true' | `bool` | `false` | no |
| source\_subnetwork\_ip\_ranges\_to\_nat | How NAT should be configured per Subnetwork | `string` | `"ALL_SUBNETWORKS_ALL_IP_RANGES"` | no |
| ssh\_source\_ranges | List of IP CIDR ranges for tag-based SSH rule | `list(string)` | `[]` | no |
| ssh\_target\_tags | List of target tags for tag-based SSH rule | `any` | `null` | no |
| subnets | The list of subnets being created | `list(map(string))` | n/a | yes |

### Subnet Inputs

See registry [examples][tf_registry] folder for additional references:

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| subnet\_name | The name of the subnet being created  | string | - | yes |
| subnet\_ip | The IP and CIDR range of the subnet being created | string | - | yes |
| subnet\_region | The region where the subnet will be created  | string | - | yes |
| subnet\_private\_access | Whether this subnet will have private Google access enabled | string | `"false"` | no |
| subnet\_flow\_logs  | Whether the subnet will record and send flow log data to logging | string | `"false"` | no |

### Route Inputs

See registry [examples][tf_registry] folder for additional references:

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| name | The name of the route being created  | string | - | no |
| description | The description of the route being created | string | - | no |
| tags | The network tags assigned to this route. This is a list in string format. Eg. "tag-01,tag-02"| string | - | yes |
| destination\_range | The destination range of outgoing packets that this route applies to. Only IPv4 is supported | string | - | yes
| next\_hop\_internet | Whether the next hop to this route will the default internet gateway. Use "true" to enable this as next hop | string | `"false"` | yes |
| next\_hop\_ip | Network IP address of an instance that should handle matching packets | string | - | yes |
| next\_hop\_instance |  URL or name of an instance that should handle matching packets. If just name is specified "next\_hop\_instance\_zone" is required | string | - | yes |
| next\_hop\_instance\_zone |  The zone of the instance specified in next\_hop\_instance. Only required if next\_hop\_instance is specified as a name | string | - | no |
| next\_hop\_vpn\_tunnel | URL to a VpnTunnel that should handle matching packets | string | - | yes |
| priority | The priority of this route. Priority is used to break ties in cases where there is more than one matching route of equal prefix length. In the case of two routes with equal prefix length, the one with the lowest-numbered priority value wins | string | `"1000"` | yes |

## Outputs

| Name | Description |
|------|-------------|
| network | The created network |
| network\_name | Name of VPC |
| network\_self\_link | VPC network self link |
| project\_id | VPC project id |
| route\_names | The route names associated with this VPC |
| subnets | A map with keys of form subnet\_region/subnet\_name and values being the outputs of the google\_compute\_subnetwork resources used to create corresponding subnets |
| subnets\_flow\_logs | Whether the subnets will have VPC flow logs enabled |
| subnets\_ip\_cidr\_ranges | The IPs and CIDRs of the subnets being created |
| subnets\_names | The names of the subnets being created |
| subnets\_private\_access | Whether the subnets will have access to Google API's without a public IP |
| subnets\_regions | The region where the subnets will be created |
| subnets\_secondary\_ranges | The secondary ranges associated with these subnets |
| subnets\_self\_links | The self-links of subnets being created |

[tf_registry]: https://github.com/terraform-google-modules/terraform-google-network/tree/master/examples