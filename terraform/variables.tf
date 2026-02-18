variable "ssh_public_key" {
  type        = string
  description = "public ssh key"
}

variable "ssh_key_name" {
  type        = string
  description = "public ssh key name"
  default     = "my_key"
}

variable "my_public_ip" {
  type        = string
  description = "my public ip for security inbound rule"
}

variable "subnet_id" {
  type        = string
  description = "the id of the subnet that will contain the ec2"
}

variable "instance_type" {
  type = object({
    application       = string
    web               = string
    app_database          = string
    iam_database      = string
    object_storage    = string
    access_management = string
    message_broker    = string
  })
  default = {
    application       = "t3.small"
    web               = "t3.micro"
    app_database          = "t3.small"
    iam_database      = "t3.micro"
    object_storage    = "t3.micro"
    access_management = "t3.micro"
    message_broker    = "t3.micro"
  }
}

variable "volume_size" {
  type = object({
    application       = number
    web               = number
    app_database          = number
    iam_database      = number
    object_storage    = number
    access_management = number
    message_broker    = number
  })
  default = {
    application       = 8
    web               = 8
    app_database          = 8
    iam_database      = 8
    object_storage    = 8
    access_management = 8
    message_broker    = 8
  }
}