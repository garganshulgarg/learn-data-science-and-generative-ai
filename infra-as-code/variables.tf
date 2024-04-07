variable "required_tags" {
  description = "Labels which will get added to virtual machine"
  type        = map(string)
  default     = {}
}
variable "vpc_id" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "allowed_ips" {
  type    = list(string)
  default = ["YOUR_IP/32", "ANOTHER_ALLOWED_IP/32"] # Update this with your IPs
}

variable "image_path" {
  type = string
}

variable "image_tag" {
  type = string
  default = "latest"
}