variable "key_name" {
  description = "SSH Key Name"
  type        = string
}
variable "allowed_source_ranges" {
  description = "Allowed IP ranges"
  type        = list(string)
}
variable "required_tags" {
  description = "Labels which will get added to virtual machine"
  type        = map(string)
  default     = {}
}
variable "vpc_id" {
  description = "Existing VPC Details"
  type        = string
}

variable "subnet_id" {
  description = "Existing Private Subnet where you want to host Instance"
  type        = string
}