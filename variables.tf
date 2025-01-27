variable "region" {
  description = "default project region"
  default = "us-central1"
}

variable "project-id" {
  description = "project id"
}

variable "subnet-cidr" {
  description = "project cidr block"
  default = "10.0.0.0/16"
}

variable "subnet-region" {
  description = "subnet region of the vpc"
  default = "us-central1"
}

variable "subnet-zone" {
  description = "subnet zone of the vpc"
  default = "us-central1-a"
}