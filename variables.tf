#
# Module interface for "DMZ" Openstack network
#
# This defines the interface (input variables and outputs) for an OpenStack
# network connected to an external ("public") network via a gateway router.

# Input variables

# Internal address range (CIDR) for subnet (e.g. "192.2.0.0/24")
variable "subnet" {
    description = "CIDR address range for subnet fixed (private) IPs"
}

# An external gateway network id returned by public-net.py
variable "external_gateway" {
    description = "Network UUID for external (public) Internet"
}

# A floating IP address pool name returned by public-net.py
variable "pool" {
    description = "Name of IP address pool for floating IPs"
    default = "public"
}

# Name that will be used to generate names of OpenStack resources
variable "name" {
    description = "Base name for network resources"
    default = "ext-net"
}

# OS_REGION_NAME in $OS_TENANT_NAME-openrc.sh from 'Download OpenStack RC File'
variable "region" {
    description = "Hosting region"
    default     = "" 
}

# Outputs

# Network uuid for Nova compute instances
output "uuid" {
    value = "${openstack_networking_network_v2.dmz.id}"
}

# A floating IP address pool name returned by public-net.py
output "pool" {
    # This output attribute is a hack to work around the inability to specify
    # explicit module dependencies in Terraform 0.4.2.
    # Use it in floatingip_v2 resources to create a dependency
    # on the ext-net module instance and ensure that
    # floating IPs are destroyed before destroying the router interface.

    # When (in Terraform 0.5?) modules are "flattened" this may no longer work,
    # but hopefully explicit module dependencies of some sort will be added.
    value = "${var.pool}"
}
