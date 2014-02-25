#!/usr/bin/env ruby

require 'newrelic_plugin'
require 'snmp'

module NewRelic::JuniperPlugin
  VERSION = '0.0.1'

  # Register and run the agent
  def self.run
    # Register this agent.
    NewRelic::Plugin::Setup.install_agent :juniper, self

    # Launch the agent; this never returns.
    NewRelic::Plugin::Run.setup_and_run
  end


  class Agent < NewRelic::Plugin::Agent::Base
    agent_guid    'com.thurmantech.nr-plugins.juniper'
    agent_version VERSION
    agent_config_options :hostname, :port, :snmp_community, :interface_indexes
    agent_human_labels('Juniper') { "#{hostname}" }

    #
    # Required, but not used
    #
    def setup_metrics
    end


    #
    # This is called on every polling cycle
    #
    def poll_cycle
      # SNMP Stuff here
      snmp = SNMP::Manager.new(:host => hostname, :port => port, :community => snmp_community)


      #
      # Device wide metrics
      #
      device = NewRelic::JuniperPlugin::Device.new snmp

      #system_version = system.get_version
      #NewRelic::PlatformLogger.debug("Found Juniper device with version: #{system_version}")
      device_cpu = device.get_cpu
      device_cpu.each_key { |m| report_metric m, "%", device_cpu[m] } unless device_cpu.nil?

      device_memory_used = device.get_memory_used
      device_memory_used.each_key { |m| report_metric m, "Mb", device_memory_used[m] } unless device_memory_used.nil?
      device_memory_total = device.get_memory_total
      device_memory_total.each_key { |m| report_metric m, "Mb", device_memory_total[m] } unless device_memory_total.nil?

      device_temp = device.get_temp
      device_temp.each_key { |m| report_metric m, "degrees", device_temp[m] } unless device_temp.nil?

      #
      # Interface Metrics
      #
      if not interface_indexes.empty?
        interface = NewRelic::JuniperPlugin::Interface.new interface_indexes, snmp

        interface_in_octets = interface.get_in_octets
        interface_in_octets.each_key { |m| report_counter_metric m, "bits/sec", interface_in_octets[m] } unless interface_in_octets.nil?

        interface_out_octets = interface.get_out_octets
        interface_out_octets.each_key { |m| report_counter_metric m, "bits/sec", interface_out_octets[m] } unless interface_out_octets.nil?

        interface_in_ucast = interface.get_in_ucast_pkts
        interface_in_ucast.each_key { |m| report_counter_metric m, "pkts/sec", interface_in_ucast[m] } unless interface_in_ucast.nil?

        interface_in_multicast = interface.get_in_multicast_pkts
        interface_in_multicast.each_key { |m| report_counter_metric m, "pkts/sec", interface_in_multicast[m] } unless interface_in_multicast.nil?

        interface_in_broadcast = interface.get_in_broadcast_pkts
        interface_in_broadcast.each_key { |m| report_counter_metric m, "pkts/sec", interface_in_broadcast[m] } unless interface_in_broadcast.nil?



        interface_out_ucast = interface.get_out_ucast_pkts
        interface_out_ucast.each_key { |m| report_counter_metric m, "pkts/sec", interface_out_ucast[m] } unless interface_out_ucast.nil?

        interface_out_multicast = interface.get_out_multicast_pkts
        interface_out_multicast.each_key { |m| report_counter_metric m, "pkts/sec", interface_out_multicast[m] } unless interface_out_multicast.nil?

        interface_out_broadcast = interface.get_out_broadcast_pkts
        interface_out_broadcast.each_key { |m| report_counter_metric m, "pkts/sec", interface_out_broadcast[m] } unless interface_out_broadcast.nil?
      end
    end


    #
    # Helper function to create and keep track of all the counters
    #
    def report_counter_metric(metric, type, value)
      @processors ||= {}

      if @processors[metric].nil?
        @processors[metric] = NewRelic::Processor::EpochCounter.new
      end

      report_metric metric, type, @processors[metric].process(value)
    end


  end
end

