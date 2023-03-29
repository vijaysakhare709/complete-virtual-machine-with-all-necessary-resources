
variable "resource-group-name" {
    default = "project1-resource-group"
}

variable "location" {
    default = "East Us"
}

variable "vnet-name" {
    default = "project1-vnet"
}

variable "vnet-address-space" {
    default = ["10.0.0.0/19"]
} 

variable "vnet-subnet1name" {
    default = "project1-subnet-1"
}

variable "vnet-subnet2name" {
    default = "project1-subnet-2"
}


variable "vnet-subnet1-address" {
    type = list
    default = ["10.0.1.0/24"]
}

variable "vnet-subnet2-address" {
    type = list
    default = ["10.0.2.0/24"]
}



variable "network-security-group-name" {
    default = "project1-vnet-nsg"
}

variable "vnet-network-sg-rule-name" {
    default = "project1-vnet-nsg-rule"
}

variable "public-ip-1-name" {
    default = "project1-vm1-public-ip"
}

variable "public-ip-2-name" {
    default = "project1-vm2-public-ip"
}

variable "vm1-network-interface-1-name" {
    default = "project1-vm-1-network-interface"
}

variable "vm1-network-interface-2-name" {
    default = "project1-vm-2-network-interface"
}

variable "linux-virtual-machine-1-name" {
    default = "project1-vm1-machine-1"
}

variable "linux-virtual-machine-2-name" {
    default = "project1-vm1-machine-2"
}


variable "vm1-machine1-size" {
    default = "Standard_B1s"
}

variable "vm1-machine2-size" {
    default = "Standard_B1s"
}





