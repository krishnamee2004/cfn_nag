# frozen_string_literal: true

require 'cfn-nag/violation'
require_relative 'base'

class EC2NetworkAclEntryPortRangeRule < BaseRule
  def rule_text
    'EC2 NetworkACL Entry Port Range must be defined for TCP/UDP protocols and not allow all ports'
  end

  def rule_type
    Violation::FAILING_VIOLATION
  end

  def rule_id
    'F80'
  end

  def audit_impl(cfn_model)
    violating_network_acl_entries = cfn_model.resources_by_type('AWS::EC2::NetworkAclEntry')
                                             .select do |network_acl_entry|
      violating_network_acl_entries?(network_acl_entry)
    end

    violating_network_acl_entries.map(&:logical_resource_id)
  end

  private

  # Port Range is required for protocols "6" (TCP) and "17" (UDP)
  def tcp_or_udp_protocol?(network_acl_entry)
    %w[6 17].include?(network_acl_entry.protocol)
  end

  def port_range_params_exist?(network_acl_entry)
    network_acl_entry.portRange.nil? ||
      network_acl_entry.portRange['From'].nil? || network_acl_entry.portRange['To'].nil?
  end

  def full_port_range?(network_acl_entry)
    (network_acl_entry.portRange['From'] == '0' && network_acl_entry.portRange['To'] == '65535') ||
      (network_acl_entry.portRange['From'] == '-1' && network_acl_entry.portRange['To'] == '-1')
  end

  def violating_network_acl_entries?(network_acl_entry)
    tcp_or_udp_protocol?(network_acl_entry) && (port_range_params_exist?(network_acl_entry) ||
      full_port_range?(network_acl_entry))
  end
end