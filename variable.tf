variable "vpc_id" {
  type = string
  default = "vpc-0a3ca044a4fe54790"
}

variable "EC2Jenkins_securitygroup_id" {
  type = string
  default = "sg-06cb9d60087b88c0e"
}

variable "image_id" {
  type = string
  default = "ami-04a37924ffe27da53"
}

variable "instance_type" {
  type = string
  default = "t2.micro"
}