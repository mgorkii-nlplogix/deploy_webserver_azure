# Azure Infrastructure Operations Project: Deploying a scalable IaaS web server in Azure

### Introduction
This project will deploy a scalable cluster of servers using Terraform tempate and server image from Packer.
### Getting Started
1. Clone this repository

2. Set up environment variables to access your azure account

3. Modify vars.tf if needed

4. Modify and Run packer image script

5. Modify and Run terraform script

### Dependencies
1. Create an [Azure Account](https://portal.azure.com) 
2. Install the [Azure command line interface](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)
3. Install [Packer](https://www.packer.io/downloads)
4. Install [Terraform](https://www.terraform.io/downloads.html)

### Instructions
1. Create your azure account, subscription, resource group for the image. If the account and subscription already exist create the resource group only. Make sure the name matches the "managed_image_resource_group_name" in server.json and vars.tf

2. Login to Azure CLI

```sh
az login
```

2. Add the following environment variables: 
```sh
ARM_CLIENT_ID
ARM_CLIENT_SECRET
ARM_SUBSCRIPTION_ID
ARM_TENANT_ID
```
To make it more consistent create a file like "env.settings" and save your varibles. Source them once you open the terminal. 

3. Create a policy definition 

```sh
az policy definition create --name tagging-policy  --rules tagging-policy.rules.json --params tagging-policy.parameters.json
```
Show the policy running the command: 

```sh
az policy definition show --name tagging-policy
```
Assign the Policy

```sh
az policy assignment create --name tagging-policy --policy tagging-policy 
```
Check the policy was assigned:

```sh
az policy assignment list
```

4. Update the packer file server.json with your region, storage and resource name. Storage might differ from region to region. 

5. Update the vars.tf file with your information. vars.tf contains default values for vm's usernames and password, resource name and location, default number of machines, packer image name and packer resource group. 

6. Run the fopllowing command to create the server image. Make sure it uses existing resource group  
```sh
packer build server.json
```
7. Run the following command to update packer. Make sure to add the created folder to gitignore
```sh
terraform init
```
8. Run the following command to check deployment plan and save it to a file. 
```sh
terraform plan -out solution.plan
```
9. Run the following command to deploy the infrastructure
```sh
terraform apply 
```
10. Destroy the infrustructure if needed: 
```sh
terraform destroy
```
### Output

After completing all the steps you will deploy the following resources: 

- resource group
- virtual network
- subnet
- network security group limiting access ( 4 minimum rules now!!!)
- network interfaces
- a public ip
- load balancer
- availability set for the virtual machines
- Linux virtual machines (3 by default)
- 1 managed disk per instance

Once the plan is created you will get output similar to that : 

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # azurerm_availability_set.main will be created
  + resource "azurerm_availability_set" "main" {
      + id                           = (known after apply)
      + location                     = "eastus"
      + managed                      = true
      + name                         = "udacity-test-aset"
      + platform_fault_domain_count  = 2
      + platform_update_domain_count = 5
      + resource_group_name          = "udacity-test-resources"
    }

  # azurerm_lb.main will be created
  + resource "azurerm_lb" "main" {
      + id                   = (known after apply)
      + location             = "eastus"
      + name                 = "udacity-test-lb"
      + private_ip_address   = (known after apply)
      + private_ip_addresses = (known after apply)
      + resource_group_name  = "udacity-test-resources"
      + sku                  = "Basic"
      + sku_tier             = "Regional"

      + frontend_ip_configuration {
          + availability_zone             = (known after apply)
          + id                            = (known after apply)
          + inbound_nat_rules             = (known after apply)
          + load_balancer_rules           = (known after apply)
          + name                          = "PublicIP"
          + outbound_rules                = (known after apply)
          + private_ip_address            = (known after apply)
          + private_ip_address_allocation = (known after apply)
          + private_ip_address_version    = (known after apply)
          + public_ip_address_id          = (known after apply)
          + public_ip_prefix_id           = (known after apply)
          + subnet_id                     = (known after apply)
          + zones                         = (known after apply)
        }
    }

  # azurerm_lb_backend_address_pool.main will be created
  + resource "azurerm_lb_backend_address_pool" "main" {
      + backend_ip_configurations = (known after apply)
      + id                        = (known after apply)
      + load_balancing_rules      = (known after apply)
      + loadbalancer_id           = (known after apply)
      + name                      = "udacity-test-lb-backend-pool"
      + outbound_rules            = (known after apply)
      + resource_group_name       = "udacity-test-resources"
    }

  # azurerm_lb_probe.main will be created
  + resource "azurerm_lb_probe" "main" {
      + id                  = (known after apply)
      + interval_in_seconds = 15
      + load_balancer_rules = (known after apply)
      + loadbalancer_id     = (known after apply)
      + name                = "http-server-probe"
      + number_of_probes    = 2
      + port                = 8080
      + protocol            = (known after apply)
      + resource_group_name = "udacity-test-resources"
    }

  # azurerm_lb_rule.main will be created
  + resource "azurerm_lb_rule" "main" {
      + backend_address_pool_id        = (known after apply)
      + backend_port                   = 8080
      + disable_outbound_snat          = false
      + enable_floating_ip             = false
      + frontend_ip_configuration_id   = (known after apply)
      + frontend_ip_configuration_name = "PublicIP"
      + frontend_port                  = 80
      + id                             = (known after apply)
      + idle_timeout_in_minutes        = (known after apply)
      + load_distribution              = (known after apply)
      + loadbalancer_id                = (known after apply)
      + name                           = "HTTP"
      + probe_id                       = (known after apply)
      + protocol                       = "Tcp"
      + resource_group_name            = "udacity-test-resources"
    }

  # azurerm_linux_virtual_machine.main[0] will be created
  + resource "azurerm_linux_virtual_machine" "main" {
      + admin_password                  = (sensitive value)
      + admin_username                  = "azureuser"
      + allow_extension_operations      = true
      + availability_set_id             = (known after apply)
      + computer_name                   = (known after apply)
      + disable_password_authentication = false
      + extensions_time_budget          = "PT1H30M"
      + id                              = (known after apply)
      + location                        = "eastus"
      + max_bid_price                   = -1
      + name                            = "udacity-test-0-vm"
      + network_interface_ids           = (known after apply)
      + platform_fault_domain           = -1
      + priority                        = "Regular"
      + private_ip_address              = (known after apply)
      + private_ip_addresses            = (known after apply)
      + provision_vm_agent              = true
      + public_ip_address               = (known after apply)
      + public_ip_addresses             = (known after apply)
      + resource_group_name             = "udacity-test-resources"
      + size                            = "Standard_B1ls"
      + source_image_id                 = "/subscriptions/37008964-1c5f-45ca-91ee-48b163a9fc12/resourceGroups/udemy-azure-packer/providers/Microsoft.Compute/images/ubuntuImage"
      + tags                            = {
          + "environment"  = "dev"
          + "project-name" = "Deploying a Web Server in Azure"
        }
      + virtual_machine_id              = (known after apply)
      + zone                            = (known after apply)

      + os_disk {
          + caching                   = "ReadWrite"
          + disk_size_gb              = (known after apply)
          + name                      = (known after apply)
          + storage_account_type      = "Standard_LRS"
          + write_accelerator_enabled = false
        }
    }

  # azurerm_linux_virtual_machine.main[1] will be created
  + resource "azurerm_linux_virtual_machine" "main" {
      + admin_password                  = (sensitive value)
      + admin_username                  = "azureuser"
      + allow_extension_operations      = true
      + availability_set_id             = (known after apply)
      + computer_name                   = (known after apply)
      + disable_password_authentication = false
      + extensions_time_budget          = "PT1H30M"
      + id                              = (known after apply)
      + location                        = "eastus"
      + max_bid_price                   = -1
      + name                            = "udacity-test-1-vm"
      + network_interface_ids           = (known after apply)
      + platform_fault_domain           = -1
      + priority                        = "Regular"
      + private_ip_address              = (known after apply)
      + private_ip_addresses            = (known after apply)
      + provision_vm_agent              = true
      + public_ip_address               = (known after apply)
      + public_ip_addresses             = (known after apply)
      + resource_group_name             = "udacity-test-resources"
      + size                            = "Standard_B1ls"
      + source_image_id                 = "/subscriptions/37008964-1c5f-45ca-91ee-48b163a9fc12/resourceGroups/udemy-azure-packer/providers/Microsoft.Compute/images/ubuntuImage"
      + tags                            = {
          + "environment"  = "dev"
          + "project-name" = "Deploying a Web Server in Azure"
        }
      + virtual_machine_id              = (known after apply)
      + zone                            = (known after apply)

      + os_disk {
          + caching                   = "ReadWrite"
          + disk_size_gb              = (known after apply)
          + name                      = (known after apply)
          + storage_account_type      = "Standard_LRS"
          + write_accelerator_enabled = false
        }
    }

  # azurerm_linux_virtual_machine.main[2] will be created
  + resource "azurerm_linux_virtual_machine" "main" {
      + admin_password                  = (sensitive value)
      + admin_username                  = "azureuser"
      + allow_extension_operations      = true
      + availability_set_id             = (known after apply)
      + computer_name                   = (known after apply)
      + disable_password_authentication = false
      + extensions_time_budget          = "PT1H30M"
      + id                              = (known after apply)
      + location                        = "eastus"
      + max_bid_price                   = -1
      + name                            = "udacity-test-2-vm"
      + network_interface_ids           = (known after apply)
      + platform_fault_domain           = -1
      + priority                        = "Regular"
      + private_ip_address              = (known after apply)
      + private_ip_addresses            = (known after apply)
      + provision_vm_agent              = true
      + public_ip_address               = (known after apply)
      + public_ip_addresses             = (known after apply)
      + resource_group_name             = "udacity-test-resources"
      + size                            = "Standard_B1ls"
      + source_image_id                 = "/subscriptions/37008964-1c5f-45ca-91ee-48b163a9fc12/resourceGroups/udemy-azure-packer/providers/Microsoft.Compute/images/ubuntuImage"
      + tags                            = {
          + "environment"  = "dev"
          + "project-name" = "Deploying a Web Server in Azure"
        }
      + virtual_machine_id              = (known after apply)
      + zone                            = (known after apply)

      + os_disk {
          + caching                   = "ReadWrite"
          + disk_size_gb              = (known after apply)
          + name                      = (known after apply)
          + storage_account_type      = "Standard_LRS"
          + write_accelerator_enabled = false
        }
    }

  # azurerm_managed_disk.main[0] will be created
  + resource "azurerm_managed_disk" "main" {
      + create_option        = "Empty"
      + disk_iops_read_write = (known after apply)
      + disk_mbps_read_write = (known after apply)
      + disk_size_gb         = 1
      + id                   = (known after apply)
      + location             = "eastus"
      + logical_sector_size  = (known after apply)
      + max_shares           = (known after apply)
      + name                 = "udacity-test-0-mdisk"
      + resource_group_name  = "udacity-test-resources"
      + source_uri           = (known after apply)
      + storage_account_type = "Standard_LRS"
      + tier                 = (known after apply)
    }

  # azurerm_managed_disk.main[1] will be created
  + resource "azurerm_managed_disk" "main" {
      + create_option        = "Empty"
      + disk_iops_read_write = (known after apply)
      + disk_mbps_read_write = (known after apply)
      + disk_size_gb         = 1
      + id                   = (known after apply)
      + location             = "eastus"
      + logical_sector_size  = (known after apply)
      + max_shares           = (known after apply)
      + name                 = "udacity-test-1-mdisk"
      + resource_group_name  = "udacity-test-resources"
      + source_uri           = (known after apply)
      + storage_account_type = "Standard_LRS"
      + tier                 = (known after apply)
    }

  # azurerm_managed_disk.main[2] will be created
  + resource "azurerm_managed_disk" "main" {
      + create_option        = "Empty"
      + disk_iops_read_write = (known after apply)
      + disk_mbps_read_write = (known after apply)
      + disk_size_gb         = 1
      + id                   = (known after apply)
      + location             = "eastus"
      + logical_sector_size  = (known after apply)
      + max_shares           = (known after apply)
      + name                 = "udacity-test-2-mdisk"
      + resource_group_name  = "udacity-test-resources"
      + source_uri           = (known after apply)
      + storage_account_type = "Standard_LRS"
      + tier                 = (known after apply)
    }

  # azurerm_network_interface.main[0] will be created
  + resource "azurerm_network_interface" "main" {
      + applied_dns_servers           = (known after apply)
      + dns_servers                   = (known after apply)
      + enable_accelerated_networking = false
      + enable_ip_forwarding          = false
      + id                            = (known after apply)
      + internal_dns_name_label       = (known after apply)
      + internal_domain_name_suffix   = (known after apply)
      + location                      = "eastus"
      + mac_address                   = (known after apply)
      + name                          = "udacity-test-0-nic"
      + private_ip_address            = (known after apply)
      + private_ip_addresses          = (known after apply)
      + resource_group_name           = "udacity-test-resources"
      + virtual_machine_id            = (known after apply)

      + ip_configuration {
          + name                          = "internal"
          + primary                       = true
          + private_ip_address            = (known after apply)
          + private_ip_address_allocation = "dynamic"
          + private_ip_address_version    = "IPv4"
          + subnet_id                     = (known after apply)
        }
    }

  # azurerm_network_interface.main[1] will be created
  + resource "azurerm_network_interface" "main" {
      + applied_dns_servers           = (known after apply)
      + dns_servers                   = (known after apply)
      + enable_accelerated_networking = false
      + enable_ip_forwarding          = false
      + id                            = (known after apply)
      + internal_dns_name_label       = (known after apply)
      + internal_domain_name_suffix   = (known after apply)
      + location                      = "eastus"
      + mac_address                   = (known after apply)
      + name                          = "udacity-test-1-nic"
      + private_ip_address            = (known after apply)
      + private_ip_addresses          = (known after apply)
      + resource_group_name           = "udacity-test-resources"
      + virtual_machine_id            = (known after apply)

      + ip_configuration {
          + name                          = "internal"
          + primary                       = true
          + private_ip_address            = (known after apply)
          + private_ip_address_allocation = "dynamic"
          + private_ip_address_version    = "IPv4"
          + subnet_id                     = (known after apply)
        }
    }

  # azurerm_network_interface.main[2] will be created
  + resource "azurerm_network_interface" "main" {
      + applied_dns_servers           = (known after apply)
      + dns_servers                   = (known after apply)
      + enable_accelerated_networking = false
      + enable_ip_forwarding          = false
      + id                            = (known after apply)
      + internal_dns_name_label       = (known after apply)
      + internal_domain_name_suffix   = (known after apply)
      + location                      = "eastus"
      + mac_address                   = (known after apply)
      + name                          = "udacity-test-2-nic"
      + private_ip_address            = (known after apply)
      + private_ip_addresses          = (known after apply)
      + resource_group_name           = "udacity-test-resources"
      + virtual_machine_id            = (known after apply)

      + ip_configuration {
          + name                          = "internal"
          + primary                       = true
          + private_ip_address            = (known after apply)
          + private_ip_address_allocation = "dynamic"
          + private_ip_address_version    = "IPv4"
          + subnet_id                     = (known after apply)
        }
    }

  # azurerm_network_interface_backend_address_pool_association.main[0] will be created
  + resource "azurerm_network_interface_backend_address_pool_association" "main" {
      + backend_address_pool_id = (known after apply)
      + id                      = (known after apply)
      + ip_configuration_name   = "internal"
      + network_interface_id    = (known after apply)
    }

  # azurerm_network_interface_backend_address_pool_association.main[1] will be created
  + resource "azurerm_network_interface_backend_address_pool_association" "main" {
      + backend_address_pool_id = (known after apply)
      + id                      = (known after apply)
      + ip_configuration_name   = "internal"
      + network_interface_id    = (known after apply)
    }

  # azurerm_network_interface_backend_address_pool_association.main[2] will be created
  + resource "azurerm_network_interface_backend_address_pool_association" "main" {
      + backend_address_pool_id = (known after apply)
      + id                      = (known after apply)
      + ip_configuration_name   = "internal"
      + network_interface_id    = (known after apply)
    }

  # azurerm_network_security_group.main will be created
  + resource "azurerm_network_security_group" "main" {
      + id                  = (known after apply)
      + location            = "eastus"
      + name                = "udacity-test-netsg"
      + resource_group_name = "udacity-test-resources"
      + security_rule       = (known after apply)
    }

  # azurerm_network_security_rule.HTTP will be created
  + resource "azurerm_network_security_rule" "HTTP" {
      + access                      = "Allow"
      + destination_address_prefix  = "*"
      + destination_port_range      = "8080"
      + direction                   = "Inbound"
      + id                          = (known after apply)
      + name                        = "http"
      + network_security_group_name = "udacity-test-netsg"
      + priority                    = 100
      + protocol                    = "Tcp"
      + resource_group_name         = "udacity-test-resources"
      + source_address_prefix       = "*"
      + source_port_range           = "*"
    }

  # azurerm_network_security_rule.Inbound-Deny will be created
  + resource "azurerm_network_security_rule" "Inbound-Deny" {
      + access                      = "Deny"
      + destination_address_prefix  = "*"
      + destination_port_range      = "*"
      + direction                   = "Inbound"
      + id                          = (known after apply)
      + name                        = "Inbound-Deny"
      + network_security_group_name = "udacity-test-netsg"
      + priority                    = 250
      + protocol                    = "*"
      + resource_group_name         = "udacity-test-resources"
      + source_address_prefix       = "*"
      + source_port_range           = "*"
    }

  # azurerm_network_security_rule.LB-Inbound will be created
  + resource "azurerm_network_security_rule" "LB-Inbound" {
      + access                      = "Allow"
      + destination_address_prefix  = "*"
      + destination_port_range      = "*"
      + direction                   = "Inbound"
      + id                          = (known after apply)
      + name                        = "LB-Inbound-Allow"
      + network_security_group_name = "udacity-test-netsg"
      + priority                    = 200
      + protocol                    = "*"
      + resource_group_name         = "udacity-test-resources"
      + source_address_prefix       = "AzureLoadBalancer"
      + source_port_range           = "*"
    }

  # azurerm_network_security_rule.Vnet-Inbound will be created
  + resource "azurerm_network_security_rule" "Vnet-Inbound" {
      + access                      = "Allow"
      + destination_address_prefix  = "VirtualNetwork"
      + destination_port_range      = "*"
      + direction                   = "Inbound"
      + id                          = (known after apply)
      + name                        = "Vnet-Inbound-Allow"
      + network_security_group_name = "udacity-test-netsg"
      + priority                    = 150
      + protocol                    = "*"
      + resource_group_name         = "udacity-test-resources"
      + source_address_prefix       = "VirtualNetwork"
      + source_port_range           = "*"
    }

  # azurerm_network_security_rule.Vnet-Outbound-Allow will be created
  + resource "azurerm_network_security_rule" "Vnet-Outbound-Allow" {
      + access                      = "Allow"
      + destination_address_prefix  = "VirtualNetwork"
      + destination_port_range      = "*"
      + direction                   = "Outbound"
      + id                          = (known after apply)
      + name                        = "Inbound-Deny"
      + network_security_group_name = "udacity-test-netsg"
      + priority                    = 300
      + protocol                    = "*"
      + resource_group_name         = "udacity-test-resources"
      + source_address_prefix       = "VirtualNetwork"
      + source_port_range           = "*"
    }

  # azurerm_public_ip.main will be created
  + resource "azurerm_public_ip" "main" {
      + allocation_method       = "Static"
      + availability_zone       = (known after apply)
      + fqdn                    = (known after apply)
      + id                      = (known after apply)
      + idle_timeout_in_minutes = 4
      + ip_address              = (known after apply)
      + ip_version              = "IPv4"
      + location                = "eastus"
      + name                    = "public-ip"
      + resource_group_name     = "udacity-test-resources"
      + sku                     = "Basic"
      + sku_tier                = "Regional"
      + zones                   = (known after apply)
    }

  # azurerm_resource_group.main will be created
  + resource "azurerm_resource_group" "main" {
      + id       = (known after apply)
      + location = "eastus"
      + name     = "udacity-test-resources"
    }

  # azurerm_subnet.main will be created
  + resource "azurerm_subnet" "main" {
      + address_prefix                                 = (known after apply)
      + address_prefixes                               = [
          + "10.0.2.0/24",
        ]
      + enforce_private_link_endpoint_network_policies = false
      + enforce_private_link_service_network_policies  = false
      + id                                             = (known after apply)
      + name                                           = "udacity-test-subnet"
      + resource_group_name                            = "udacity-test-resources"
      + virtual_network_name                           = "udacity-test-network"
    }

  # azurerm_subnet_network_security_group_association.main will be created
  + resource "azurerm_subnet_network_security_group_association" "main" {
      + id                        = (known after apply)
      + network_security_group_id = (known after apply)
      + subnet_id                 = (known after apply)
    }

  # azurerm_virtual_machine_data_disk_attachment.main[0] will be created
  + resource "azurerm_virtual_machine_data_disk_attachment" "main" {
      + caching                   = "ReadWrite"
      + create_option             = "Attach"
      + id                        = (known after apply)
      + lun                       = 0
      + managed_disk_id           = (known after apply)
      + virtual_machine_id        = (known after apply)
      + write_accelerator_enabled = false
    }

  # azurerm_virtual_machine_data_disk_attachment.main[1] will be created
  + resource "azurerm_virtual_machine_data_disk_attachment" "main" {
      + caching                   = "ReadWrite"
      + create_option             = "Attach"
      + id                        = (known after apply)
      + lun                       = 10
      + managed_disk_id           = (known after apply)
      + virtual_machine_id        = (known after apply)
      + write_accelerator_enabled = false
    }

  # azurerm_virtual_machine_data_disk_attachment.main[2] will be created
  + resource "azurerm_virtual_machine_data_disk_attachment" "main" {
      + caching                   = "ReadWrite"
      + create_option             = "Attach"
      + id                        = (known after apply)
      + lun                       = 20
      + managed_disk_id           = (known after apply)
      + virtual_machine_id        = (known after apply)
      + write_accelerator_enabled = false
    }

  # azurerm_virtual_network.main will be created
  + resource "azurerm_virtual_network" "main" {
      + address_space         = [
          + "10.0.0.0/22",
        ]
      + dns_servers           = (known after apply)
      + guid                  = (known after apply)
      + id                    = (known after apply)
      + location              = "eastus"
      + name                  = "udacity-test-network"
      + resource_group_name   = "udacity-test-resources"
      + subnet                = (known after apply)
      + vm_protection_enabled = false
    }

Plan: 31 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + lb_url = (known after apply)
