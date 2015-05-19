/*
 * OpenStack "DMZ" (externally connected) network configuration
 */

#
# Neutron networking
#

# "DMZ" network is connected by Neutron router/gateway to public (floating) IPs
resource "openstack_networking_network_v2" "dmz" {
    region = "${var.region}"
    name = "${var.name}"
    admin_state_up = "true"
    shared = "false"
    tenant_id = "${var.tenant_id}"
}

# "DMZ" subnet CIDR as specified in module inputs
resource "openstack_networking_subnet_v2" "dmz_subnet" {
    region = "${var.region}"
    name = "${var.name}-subnet"
    network_id = "${openstack_networking_network_v2.dmz.id}"
    cidr = "${var.subnet}"
    ip_version = 4
    enable_dhcp = "true"
    tenant_id = "${var.tenant_id}"
}

# Gateway router between external gateway network and dmz subnet
resource "openstack_networking_router_v2" "gateway" {
    region = "${var.region}"
    name = "${var.name}-gateway"
    admin_state_up = "true"
    external_gateway = "${var.external_gateway}"
    tenant_id = "${var.tenant_id}"
}
 
resource "openstack_networking_router_interface_v2" "gateway_dmz" {
    region = "${var.region}"
    router_id = "${openstack_networking_router_v2.gateway.id}"
    subnet_id = "${openstack_networking_subnet_v2.dmz_subnet.id}"
}
