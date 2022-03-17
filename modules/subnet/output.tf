#output subnet 

output "subnets" {
  value = {
    for subnet_name, address_prefix in var.subnets_map :
    subnet_name => {
      name              = subnet_name
      id                = azurerm_subnet.subnet[subnet_name].id
      address_prefix    = address_prefix
    }
  }
}

# Docs here https://www.terraform.io/language/expressions/for
