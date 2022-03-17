# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used


terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.91.0"
    }
  }

}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}

  skip_provider_registration = true
}


module "m_rg_hub" {
  source = "../modules/resourcegroup"

  name     = var.hub_rg_name
  location = var.location

}

module "m_rg_spoke1" {
  source = "../modules/resourcegroup"

  name     = var.spoke1_rg_name
  location = var.location

}

module "m_rg_spoke2" {
  source = "../modules/resourcegroup"

  name     = var.spoke2_rg_name
  location = var.location

}

module "m_vnet_hub" {
  source = "../modules/vnet"

  name          = var.hub_vnet_name
  location      = var.location
  rg_name       = module.m_rg_hub.rg_name
  address_space = ["10.2.0.0/21"]
}

module "m_vnet_spoke1" {
  source = "../modules/vnet"

  name          = var.spoke1_vnet_name
  location      = var.location
  rg_name       = module.m_rg_spoke1.rg_name
  address_space = ["10.2.8.0/21"]
}

module "m_vnet_spoke2" {
  source = "../modules/vnet"

  name          = var.spoke2_vnet_name
  location      = var.location
  rg_name       = module.m_rg_spoke2.rg_name
  address_space = ["10.2.16.0/21"]
}

module "m_subnet_hub" {
  source = "../modules/subnet"

  vnet_name = module.m_vnet_hub.vnet_name
  rg_name   = module.m_rg_hub.rg_name

  subnets_map = {
    AzureBastionSubnet  = ["10.2.0.0/26"],
    AzureFirewallSubnet = ["10.2.0.128/26"]
  }

}

module "m_subnet_spoke1" {
  source = "../modules/subnet"

  vnet_name = module.m_vnet_spoke1.vnet_name
  rg_name   = module.m_rg_spoke1.rg_name

  subnets_map = {
    Spoke1_VM_Subnet = ["10.2.8.0/25"]
  }

}

module "m_subnet_spoke2" {
  source = "../modules/subnet"

  vnet_name = module.m_vnet_spoke2.vnet_name
  rg_name   = module.m_rg_spoke2.rg_name

  subnets_map = {
    Spoke2_VM_Subnet = ["10.2.16.0/25"]
  }

}

module "m_vnet_hub_spoke1_peering" {
  source            = "../modules/vnet_peering"
  vnet_peering_name = "hub-spoke1-peering-hars-demo"
  rg_name           = module.m_rg_hub.rg_name
  vnet_name         = module.m_vnet_hub.vnet_name
  remote_vnet_id    = module.m_vnet_spoke1.vnet_id
}

module "m_vnet_spoke1_hub_peering" {
  source            = "../modules/vnet_peering"
  vnet_peering_name = "spoke1-hub-peering-hars-demo"
  rg_name           = module.m_rg_spoke1.rg_name
  vnet_name         = module.m_vnet_spoke1.vnet_name
  remote_vnet_id    = module.m_vnet_hub.vnet_id
  allow_forwarded_traffic = true
}

module "m_vnet_hub_spoke2_peering" {
  source            = "../modules/vnet_peering"
  vnet_peering_name = "hub-spoke2-peering-hars-demo"
  rg_name           = module.m_rg_hub.rg_name
  vnet_name         = module.m_vnet_hub.vnet_name
  remote_vnet_id    = module.m_vnet_spoke2.vnet_id
}

module "m_vnet_spoke2_hub_peering" {
  source            = "../modules/vnet_peering"
  vnet_peering_name = "spoke2-hub-peering-hars-demo"
  rg_name           = module.m_rg_spoke2.rg_name
  vnet_name         = module.m_vnet_spoke2.vnet_name
  remote_vnet_id    = module.m_vnet_hub.vnet_id
  allow_forwarded_traffic = true
}


module "m_bastion_pip_hub" {
  source = "../modules/pip"

  pip_name          = "hub-bastion-pip-hars-demo"
  rg_name           = module.m_rg_hub.rg_name
  location          = var.location
  allocation_method = "Static"
  sku               = "Standard"
}

module "m_bastion_host_hub" {
  source = "../modules/bastionhost"

  bastion_host_name = "hub-bastion-host"
  rg_name           = module.m_rg_hub.rg_name
  location          = var.location
  subnet_id         = module.m_subnet_hub.subnets.AzureBastionSubnet.id
  pip_id            = module.m_bastion_pip_hub.pip_id
}

module "m_nic_spoke1_vm1" {
  source    = "../modules/nic"
  nic_name  = "spoke1-nic-vm1-hars-demo"
  rg_name   = module.m_rg_spoke1.rg_name
  location  = var.location
  subnet_id = module.m_subnet_spoke1.subnets.Spoke1_VM_Subnet.id

}

module "m_nic_spoke2_vm1" {
  source    = "../modules/nic"
  nic_name  = "spoke2-nic-vm1-hars-demo"
  rg_name   = module.m_rg_spoke2.rg_name
  location  = var.location
  subnet_id = module.m_subnet_spoke2.subnets.Spoke2_VM_Subnet.id

}

module "m_winodw_vm1_spoke1" {
  source = "../modules/window_vm"

  vm_name        = "spoke1-vm1-hars-demo"
  computer_name  = "spoke1-vm1"
  rg_name        = module.m_rg_spoke1.rg_name
  location       = var.location
  size           = "Standard_F2"
  admin_username = "spoke1-vm1"
  admin_password = "DemoVM@1234"
  nic_id_list    = [module.m_nic_spoke1_vm1.nic_id]
}

module "m_winodw_vm1_spoke2" {
  source = "../modules/window_vm"

  vm_name        = "spoke2-vm1-hars-demo"
  computer_name  = "spoke2-vm1"
  rg_name        = module.m_rg_spoke2.rg_name
  location       = var.location
  size           = "Standard_F2"
  admin_username = "spoke2-vm1"
  admin_password = "DemoVM@1234"
  nic_id_list    = [module.m_nic_spoke2_vm1.nic_id]
}

module "m_firewall_pip_hub" {
  source = "../modules/pip"

  pip_name          = "hub-firewall-pip-hars-demo"
  rg_name           = module.m_rg_hub.rg_name
  location          = var.location
  allocation_method = "Static"
  sku               = "Standard"
}

module "m_hub_firewall" {
  source = "../modules/firewall"

  fw_name      = var.fw_name
  rg_name      = module.m_rg_hub.rg_name
  location     = var.location
  fw_subnet_id = module.m_subnet_hub.subnets.AzureFirewallSubnet.id
  fw_pip_id    = module.m_firewall_pip_hub.pip_id
}

module "m_spoke1_routetable" {
  source = "../modules/routetable"

  rt_table               = "spoke1-rt-hars-demo"
  rg_name                = module.m_rg_spoke1.rg_name
  location               = var.location
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = module.m_hub_firewall.fw_ip_configuration[0].private_ip_address
}

module "m_spoke2_routetable" {
  source = "../modules/routetable"

  rt_table               = "spoke2-rt-hars-demo"
  rg_name                = module.m_rg_spoke2.rg_name
  location               = var.location
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = module.m_hub_firewall.fw_ip_configuration[0].private_ip_address
}

resource "azurerm_subnet_route_table_association" "spoke1-rt-subnet-association" {
  subnet_id      = module.m_subnet_spoke1.subnets.Spoke1_VM_Subnet.id
  route_table_id = module.m_spoke1_routetable.rt_id
}

resource "azurerm_subnet_route_table_association" "spoke2-rt-subnet-association" {
  subnet_id      = module.m_subnet_spoke2.subnets.Spoke2_VM_Subnet.id
  route_table_id = module.m_spoke2_routetable.rt_id
}

# Firewall NetWork rules
resource "azurerm_firewall_network_rule_collection" "fw-network-rule-collection" {
  name                = "all-traffic-fw-net"
  azure_firewall_name = var.fw_name
  resource_group_name = module.m_rg_hub.rg_name
  priority            = 1000
  action              = "Allow"

  rule {
    name = "spoke1-all-traffic"

    source_addresses = [
      module.m_nic_spoke1_vm1.nic_private_ip
    ]

    destination_ports = [
      "*"
    ]

    destination_addresses = [
      "*"
    ]

    protocols = [
      "Any"
    ]
  }

  rule {
    name = "spoke2-all-traffic"

    source_addresses = [
      module.m_nic_spoke2_vm1.nic_private_ip
    ]

    destination_ports = [
      "*"
    ]

    destination_addresses = [
      "*"
    ]

    protocols = [
      "Any"
    ]
  }


}

