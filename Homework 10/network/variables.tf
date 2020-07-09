variable "vpc_cidr" {
  description = "CIDR VPC"
  default     = "10.10.0.0/17"
}

variable "public_subnet_cidr" {
  description = "Public Subnet"
  default     = "10.10.0.0/18"
}

variable "private_subnet_cidr" {
  description = "Private Subnet"
  default     = "10.10.64.0/18"
}
