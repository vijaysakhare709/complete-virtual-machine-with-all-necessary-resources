terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.91.0"
    }
  }
}

provider "azurerm" {
  features {}
}


# Creating azure resource group

resource "azurerm_resource_group" "vijay" {
  name     = "${var.resource-group-name}"
  location = "${var.location}"
  tags = {
    environement = "dev"
  }
}

# creating virtual network (Vnet) 

resource "azurerm_virtual_network" "virtualnetwork" {
  name                = "${var.vnet-name}"
  resource_group_name = "${azurerm_resource_group.vijay.name}"
  location            = "${var.location}"
  address_space       = "${var.vnet-address-space}"

  tags = {
    environement = "dev"
  }
}

# Creating multipal subnet in vnet (type = list)

resource "azurerm_subnet" "virtualsubnet1" {
  name                 =  "${var.vnet-subnet1name}"
  resource_group_name  = "${azurerm_resource_group.vijay.name}"
  virtual_network_name = "${azurerm_virtual_network.virtualnetwork.name}"
  address_prefixes     = "${var.vnet-subnet1-address}"

}

resource "azurerm_subnet" "virtualsubnet2" {
  name                 =  "${var.vnet-subnet2name}"
  resource_group_name  = "${azurerm_resource_group.vijay.name}"
  virtual_network_name = "${azurerm_virtual_network.virtualnetwork.name}"
  address_prefixes     = "${var.vnet-subnet2-address}"

}




resource "azurerm_network_security_group" "vijay-nsg" {
  name                = "${var.network-security-group-name}"
  resource_group_name = "${azurerm_resource_group.vijay.name}"
  location            = "${var.location}"
  

  tags = {
    environment = "dev"
  }
}



resource "azurerm_network_security_rule" "vijay-nsg-rule" {
  name                        = "${var.vnet-network-sg-rule-name}"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${azurerm_resource_group.vijay.name}"
  network_security_group_name = "${azurerm_network_security_group.vijay-nsg.name}"
}

resource "azurerm_subnet_network_security_group_association" "vijay-assocation1" {
  subnet_id                 = "${azurerm_subnet.virtualsubnet1.id}"
  network_security_group_id = "${azurerm_network_security_group.vijay-nsg.id}"
}

resource "azurerm_subnet_network_security_group_association" "vijay-assocation2" {
  subnet_id                 = "${azurerm_subnet.virtualsubnet2.id}"
  network_security_group_id = "${azurerm_network_security_group.vijay-nsg.id}"
}




resource "azurerm_public_ip" "public-ip-1" {
  name                = "${var.public-ip-1-name}"
  resource_group_name = "${azurerm_resource_group.vijay.name}"
  location            = "${var.location}"
  allocation_method   = "Dynamic"

  tags = {
    environment = "dev"
  }
}


resource "azurerm_public_ip" "public-ip-2" {
  name                = "${var.public-ip-2-name}"
  resource_group_name = "${azurerm_resource_group.vijay.name}"
  location            = "${var.location}"
  allocation_method   = "Dynamic"

  tags = {
    environment = "dev"
  }
}


resource "azurerm_network_interface" "vijay-interfaced-1" {
  name                = "${var.vm1-network-interface-1-name}"
  location            = "${azurerm_resource_group.vijay.location}"
  resource_group_name = "${azurerm_resource_group.vijay.name}"

  ip_configuration {
    name                          = "internal"
    subnet_id                     = "${azurerm_subnet.virtualsubnet1.id}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = "${azurerm_public_ip.public-ip-1.id}"
  }
  tags = {
    environment = "dev"
  }

}

resource "azurerm_network_interface" "vijay-interfaced-2" {
  name                = "${var.vm1-network-interface-2-name}"
  location            = "${azurerm_resource_group.vijay.location}"
  resource_group_name = "${azurerm_resource_group.vijay.name}"

  ip_configuration {
    name                          = "internal"
    subnet_id                     = "${azurerm_subnet.virtualsubnet2.id}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = "${azurerm_public_ip.public-ip-2.id}"
  }
  tags = {
    environment = "dev"
  }

}

resource "azurerm_linux_virtual_machine" "vijhellaymahcine-1" {
  name                  = "${var.linux-virtual-machine-1-name}"
  resource_group_name   = "${azurerm_resource_group.vijay.name}"
  location              = "${var.location}"
  size                  = "${var.vm1-machine1-size}"
  admin_username        = "adminuser"
  network_interface_ids = [azurerm_network_interface.vijay-interfaced-1.id]

  custom_data = filebase64("customdata.tpl")


  admin_ssh_key {
    username   = "adminuser"
    public_key = file("${path.module}/vijaykey.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  tags = {
    environment = "dev"
  }

}


resource "azurerm_linux_virtual_machine" "vijhellaymahcine-2" {
  name                  = "${var.linux-virtual-machine-2-name}"
  resource_group_name   = "${azurerm_resource_group.vijay.name}"
  location              = "${var.location}"
  size                  = "${var.vm1-machine2-size}"
  admin_username        = "adminuser"
  network_interface_ids = [azurerm_network_interface.vijay-interfaced-2.id]

  custom_data = filebase64("customdata.tpl")


  admin_ssh_key {
    username   = "adminuser"
    public_key = file("${path.module}/vijaykey.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  tags = {
    environment = "dev"
  }

}

/*

data "azurerm_public_ip" "public-ip" {
  name                = azurerm_public_ip.public-ip.name
  resource_group_name = azurerm_resource_group.vijay.name
}


output "network_interface_private_ip" {
  description = "private ip addresses of the vm nics"
  value       = "${azurerm_network_interface.vijay-interfaced.*.private_ip_address}"
}

output "public_ip_address1" {
  value = "${azurerm_public_ip.public-ip-1.*.ip_address}"
}
output "public_ip_address2" {
  value = "${azurerm_public_ip.public-ip-2.*.ip_address}"
}
/*
output "public_ip_address" {
  value = "${azurerm_linux_virtual_machine.vijhellaymahcine.*.public_ip_address}"
}
*/
