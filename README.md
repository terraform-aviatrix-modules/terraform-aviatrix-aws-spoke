# terraform-aviatrix-aws-spoke

### Description
This module deploys a very simple spoke VPC, with a public and a private subnet in each availability zone. Transit gateways are created in the public subnets of the 2 first AZ's.

### Compatibility
Module version | Terraform version | Controller version | Terraform provider version
:--- | :--- | :--- | :---
v1.1.0 | 0.12 | | 
v1.0.2 | 0.12 | | 
v1.0.1 | 0.12 | |
v1.0.0 | 0.12 | |

### Diagram
<img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-aws-spoke/blob/master/img/spoke-vpc-aws-ha.png?raw=true">

with ha_gw set to false, the following will be deployed:

<img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-aws-spoke/blob/master/img/spoke-vpc-aws.png?raw=true">

### Usage Example
```
module "spoke_aws_1" {
  source  = "terraform-aviatrix-modules/aws-spoke/aviatrix"
  version = "1.1.0"

  name = "App1"
  cidr = "10.1.0.0/20"
  region = "eu-west-1"
  account = "AWS"
  transit_gw = "avx-eu-west-1-transit"
}
```

### Variables
The following variables are required:

key | value
:--- | :---
name | Name for this spoke VPC and it's gateways
region | AWS region to deploy this VPC in
cidr | What ip CIDR to use for this VPC
account | The account name as known by the Aviatrix controller
transit_gw | The name of the transit gateway we want to attach this spoke to

The following variables are optional:

key | default | value 
:---|:---|:---
instance_size | t3.medium | The size of the Aviatrix spoke gateways
ha_gw | true | Set to false if you only want to deploy a single Aviatrix spoke gateway
insane_mode | false | Set to true to enable insane mode encryption
az1 | "a" | concatenates with region to form az names. e.g. eu-central-1a. Used for insane mode only.
az2 | "b" | concatenates with region to form az names. e.g. eu-central-1b. Used for insane mode only.
active_mesh | true | Set to false to disable active mesh.

### Outputs
This module will return the following outputs:

key | description
:---|:---
vpc | The created VPC as an object with all of it's attributes. This was created using the aviatrix_vpc resource.
spoke_gateway | The created Aviatrix spoke gateway as an object with all of it's attributes.
