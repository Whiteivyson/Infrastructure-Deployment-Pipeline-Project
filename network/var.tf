variable "BeatStar" {
  description = "Prefix for naming resources"
  type        = string
}

variable "cidr_block" {
    type = string
    description = "vpc cidr range"
    default = "10.0.0.0/16"
}



variable "public_subnet" {
  type = map(object({
    cidr_block = string
    az         = string
  }))

  default = {
    "public_subnet_1" = {
      cidr_block = "10.0.16.0/28"
      az         = "us-east-1c"
    }
    "public_subnet_2" = {
      cidr_block = "10.0.10.0/28"
      az         = "us-east-1b"
    }
  }
}
variable "availability_zone" {
    type = list(string)
    description = "List of availability zones"
    default = ["us-east-1a", "us-east-1b", "us-east-1c"]
}





variable "private_subnet_cidr" {
    type = string
    description = "Private subnet cidr range"
    default = "10.0.15.0/28"
}