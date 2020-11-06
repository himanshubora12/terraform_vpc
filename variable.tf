
variable "vpc_cidr" {
  default = "192.168.16.0/24"
}

variable "pub_cidr" {
  type = list
  default = ["192.168.16.128/26", "192.168.16.192/26"]
}

variable "pvt_cidr" {
  type = list
  default = ["192.168.16.0/26", "192.168.16.64/26"]
}

