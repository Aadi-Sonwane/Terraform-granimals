# modules/vpc/variables.tf

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR block"
}

variable "existing_vpc_id" {
  type        = string
  description = "Optional: ID of an existing VPC to use. If not provided, a new VPC will be created."
  default     = null
}