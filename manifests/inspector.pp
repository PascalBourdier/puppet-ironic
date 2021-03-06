#
# Copyright (C) 2015 Red Hat, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.

# Configure the ironic-inspector auxiliary service to Ironic
#
# === Parameters
#
# [*package_ensure*]
#   (optional) Control the ensure parameter for the package resource
#   Defaults to 'present'
#
# [*enabled*]
#   (optional) Define if the service must be enabled or not
#   Defaults to true
#
# [*listen_address*]
#   (optional) The listen IP for the Ironic-inspector API server.
#   Should be an valid IP address
#   Defaults to $::os_service_default.
#
# [*pxe_transfer_protocol*]
#  (optional) Protocol to be used for transferring the ramdisk
#  Defaults to 'tftp'. Valid values are 'tftp' or 'http'.
#
# [*debug*]
#   (optional) Enable debug logging
#   Defaults to undef
#
# [*auth_strategy*]
#   (optional) API authentication strategy: keystone or noauth
#   Defaults to 'keystone'
#
# [*dnsmasq_interface*]
#   (optional) The interface for the ironic-inspector dnsmasq process
#   to listen on
#   Defaults to 'br-ctlplane'
#
# [*db_connection*]
#   (optional) Location of the ironic-inspector node cache database
#   Defaults to undef
#
# [*ramdisk_logs_dir*]
#   (optional) Location to store logs retrieved from the ramdisk
#   Defaults to '/var/log/ironic-inspector/ramdisk/'
#
# [*enable_setting_ipmi_credentials*]
#   (optional) Enable setting of IPMI credentials
#   Defaults to false
#
# [*keep_ports*]
#   (optional) Which ports to keep after introspection
#   Defaults to 'all'
#
# [*store_data*]
#   (optional) Method for storing introspection data
#   Defaults to 'none'
#
# [*ironic_auth_type*]
#   (optional) Authentication plugin for accessing Ironic
#   Defaults to 'password'
#
# [*ironic_username*]
#   (optional) User name for accessing Ironic API
#   Defaults to 'ironic'
#
# [*ironic_password*]
#   (optional) Password for accessing Ironic API
#   Defaults to undef. Set a value unless using noauth.
#
# [*ironic_tenant_name*]
#   (optional) Tenant name for accessing Ironic API
#   Defaults to 'services'
#
# [*ironic_auth_url*]
#   (optional) Keystone authentication URL for Ironic
#   Defautls to 'http://127.0.0.1:5000/v2.0'
#
# [*ironic_max_retries*]
#   (optional) Maximum number of retries in case of conflict error
#   Defaults to 30
#
# [*ironic_retry_interval*]
#   (optional) Interval between retries in case of conflict error
#   Defaults to 2
#
# [*swift_auth_type*]
#   (optional) Authentication plugin for accessing Swift
#   Defaults to 'password'
#
# [*swift_username*]
#   (optional) User name for accessing Swift API
#   Defaults to 'ironic'
#
# [*swift_password*]
#   (optional) Password for accessing Swift API
#   Defaults to undef. Set a value if using Swift.
#
# [*swift_tenant_name*]
#   (optional) Tenant name for accessing Swift API
#   Defaults to 'services'
#
# [*swift_auth_url*]
#   (optional) Keystone authentication URL for Swift
#   Defautls to 'http://127.0.0.1:5000/v2.0'
#
# [*dnsmasq_ip_range*]
#   (optional) IP range to use for nodes being introspected
#   Defaults to '192.168.0.100,192.168.0.120'
#
# [*dnsmasq_local_ip*]
#   (optional) IP interface for the dnsmasq process
#   Defaults to '192.168.0.1'
#
# [*sync_db*]
#   Enable dbsync
#   Defaults to true
#
# [*ramdisk_collectors*]
#   Comma-separated list of IPA inspection collectors
#   Defaults to 'default'
#
# [*additional_processing_hooks*]
#   Comma-separated list of processing hooks to append to the default list.
#   Defaults to undef
#
# [*ramdisk_kernel_args*]
#   String with kernel arguments to send to the ramdisk on boot.
#   Defaults to undef
#
# [*ipxe_timeout*]
#   (optional) ipxe timeout in second. Should be an integer.
#   Defaults to $::os_service_default
#
# [*http_port*]
#   (optional) port used by the HTTP service serving introspection images.
#   Defaults to 8088.
#
# [*tftp_root*]
#   (optional) Folder location to deploy PXE boot files
#   Defaults to '/tftpboot'
#
# [*http_root*]
#   (optional) Folder location to deploy HTTP PXE boot
#   Defaults to '/httpboot'
#
# [*detect_boot_mode*]
#   (optional) Whether to store the boot mode (BIOS or UEFI).
#   Defaults to $::os_service_default
#
# [*node_not_found_hook*]
#   (optional) Plugin to run when a node is not found during lookup.
#   For example, "enroll" hook can be used for node auto-discovery.
#   Defaults to $::os_service_default
#
# [*discovery_default_driver*]
#   (optional) The default driver to use for auto-discovered nodes.
#   Requires node_not_found_hook set to "enroll".
#   Defaults to $::os_service_default
#
# DEPRECATED
#
# [*enable_uefi*]
#  (optional) Allow introspection of machines with UEFI firmware.
#  This parameter is deprecated and will be removed. UEFI will always be
#  enabled. Ignored unless $pxe_transfer_protocol='http'.
#  Defaults to false.
#
class ironic::inspector (
  $package_ensure                  = 'present',
  $enabled                         = true,
  $listen_address                  = $::os_service_default,
  $pxe_transfer_protocol           = 'tftp',
  $debug                           = undef,
  $auth_strategy                   = 'keystone',
  $dnsmasq_interface               = 'br-ctlplane',
  $db_connection                   = undef,
  $ramdisk_logs_dir                = '/var/log/ironic-inspector/ramdisk/',
  $enable_setting_ipmi_credentials = false,
  $keep_ports                      = 'all',
  $store_data                      = 'none',
  $ironic_auth_type                = 'password',
  $ironic_username                 = 'ironic',
  $ironic_password                 = undef,
  $ironic_tenant_name              = 'services',
  $ironic_auth_url                 = 'http://127.0.0.1:5000/v2.0',
  $ironic_max_retries              = 30,
  $ironic_retry_interval           = 2,
  $swift_auth_type                 = 'password',
  $swift_username                  = 'ironic',
  $swift_password                  = undef,
  $swift_tenant_name               = 'services',
  $swift_auth_url                  = 'http://127.0.0.1:5000/v2.0',
  $dnsmasq_ip_range                = '192.168.0.100,192.168.0.120',
  $dnsmasq_local_ip                = '192.168.0.1',
  $sync_db                         = true,
  $ramdisk_collectors              = 'default',
  $additional_processing_hooks     = undef,
  $ramdisk_kernel_args             = undef,
  $ipxe_timeout                    = $::os_service_default,
  $http_port                       = '8088',
  $detect_boot_mode                = $::os_service_default,
  $tftp_root                       = '/tftpboot',
  $http_root                       = '/httpboot',
  $node_not_found_hook             = $::os_service_default,
  $discovery_default_driver        = $::os_service_default,
  # DEPRECATED
  $enable_uefi                     = undef,
) {

  include ::ironic::deps
  include ::ironic::params
  include ::ironic::pxe::common
  include ::ironic::inspector::logging
  include ::ironic::inspector::db

  if $auth_strategy == 'keystone' {
    include ::ironic::inspector::authtoken
  }

  if $enable_uefi == undef {
    warning('UEFI will be enabled by default starting with Pike')
  } else {
    warning('enable_uefi is deprecated and will be hardcoded to true in Pike')
  }

  warning("After Newton cycle ::ironic::inspector won't provide \
tftpboot and httpboot setup, please include ::ironic::pxe")

  include ::ironic::pxe

  $tftp_root_real = pick($::ironic::pxe::common::tftp_root, $tftp_root)
  $http_root_real = pick($::ironic::pxe::common::http_root, $http_root)
  $http_port_real = pick($::ironic::pxe::common::http_port, $http_port)
  $ipxe_timeout_real     = pick($::ironic::pxe::common::ipxe_timeout, $ipxe_timeout)

  file { '/etc/ironic-inspector/inspector.conf':
    ensure  => 'present',
    require => Anchor['ironic-inspector::config::begin'],
  }

  if $pxe_transfer_protocol == 'tftp' {
    file { '/etc/ironic-inspector/dnsmasq.conf':
      ensure  => 'present',
      content => template('ironic/inspector_dnsmasq_tftp.erb'),
      require => Anchor['ironic-inspector::config::begin'],
    }
    file { "${tftp_root_real}/pxelinux.cfg/default":
      ensure  => 'present',
      seltype => 'tftpdir_t',
      owner   => 'ironic-inspector',
      group   => 'ironic-inspector',
      content => template('ironic/inspector_pxelinux_cfg.erb'),
      require => Anchor['ironic-inspector::config::begin'],
    }
  }

  if $pxe_transfer_protocol == 'http' {
    file { '/etc/ironic-inspector/dnsmasq.conf':
      ensure  => 'present',
      content => template('ironic/inspector_dnsmasq_http.erb'),
      require => Anchor['ironic-inspector::config::begin'],
    }
    file { "${http_root_real}/inspector.ipxe":
      ensure  => 'present',
      seltype => 'httpd_sys_content_t',
      owner   => 'ironic-inspector',
      group   => 'ironic-inspector',
      content => template('ironic/inspector_ipxe.erb'),
      require => Anchor['ironic-inspector::config::begin'],
    }
  }

  # Configure inspector.conf

  #Processing hooks string
  #Moved here in favor of removing the
  #140 chars exeeded error in puppet-lint
  $p_hooks = join(delete_undef_values(['$default_processing_hooks', $additional_processing_hooks]), ',')

  ironic_inspector_config {
    'DEFAULT/listen_address':                     value => $listen_address;
    'DEFAULT/auth_strategy':                      value => $auth_strategy;
    'capabilities/boot_mode':                     value => $detect_boot_mode;
    'firewall/dnsmasq_interface':                 value => $dnsmasq_interface;
    'processing/ramdisk_logs_dir':                value => $ramdisk_logs_dir;
    'processing/enable_setting_ipmi_credentials': value => $enable_setting_ipmi_credentials;
    'processing/keep_ports':                      value => $keep_ports;
    'processing/store_data':                      value => $store_data;
    'ironic/auth_type':                           value => $ironic_auth_type;
    'ironic/username':                            value => $ironic_username;
    'ironic/password':                            value => $ironic_password, secret => true;
    'ironic/project_name':                        value => $ironic_tenant_name;
    'ironic/auth_url':                            value => $ironic_auth_url;
    'ironic/max_retries':                         value => $ironic_max_retries;
    'ironic/retry_interval':                      value => $ironic_retry_interval;
    'swift/auth_type':                            value => $swift_auth_type;
    'swift/username':                             value => $swift_username;
    'swift/password':                             value => $swift_password, secret => true;
    'swift/project_name':                         value => $swift_tenant_name;
    'swift/auth_url':                             value => $swift_auth_url;
    # Here we use oslo.config interpolation with another option default_processing_hooks,
    # which we don't change as it might break introspection completely.
    'processing/processing_hooks':                value => $p_hooks;
    'processing/node_not_found_hook':             value => $node_not_found_hook;
    'discovery/enroll_node_driver':               value => $discovery_default_driver;
  }

  # Install package
  if $::ironic::params::inspector_package {
    package { 'ironic-inspector':
      ensure => $package_ensure,
      name   => $::ironic::params::inspector_package,
      tag    => ['openstack', 'ironic-inspector-package'],
    }
  }

  if $sync_db {
    include ::ironic::inspector::db::sync
  }

  if $enabled {
    $ensure = 'running'
  } else {
    $ensure = 'stopped'
  }

  # Manage services
  service { 'ironic-inspector':
    ensure    => $ensure,
    name      => $::ironic::params::inspector_service,
    enable    => $enabled,
    hasstatus => true,
    tag       => 'ironic-inspector-service',
  }
  Keystone_endpoint<||> -> Service['ironic-inspector']

  service { 'ironic-inspector-dnsmasq':
    ensure    => $ensure,
    name      => $::ironic::params::inspector_dnsmasq_service,
    enable    => $enabled,
    hasstatus => true,
    tag       => 'ironic-inspector-dnsmasq-service',
  }

}
