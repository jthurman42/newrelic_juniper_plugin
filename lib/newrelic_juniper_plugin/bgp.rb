#!/usr/bin/env ruby

require 'newrelic_plugin'
require 'snmp'

module NewRelic
  module JuniperPlugin

    class BGP
      attr_accessor :snmp_manager

      # Juniper Specific
      OID_JNX_BGP_M2                             = "1.3.6.1.4.1.2636.5.1.1"
      OID_JNX_BGP_M2_PEER                        = "#{OID_JNX_BGP_M2}.2"
      OID_JNX_BGP_M2_PEER_DATA                   = "#{OID_JNX_BGP_M2_PEER}.1"

      OID_JNX_BGP_M2_PEER_TABLE                  = "#{OID_JNX_BGP_M2_PEER_DATA}.1"
      OID_JNX_BGP_M2_PEER_ENTRY                  = "#{OID_JNX_BGP_M2_PEER_TABLE}.1"
      OID_JNX_BGP_M2_PEER_STATE                  = "#{OID_JNX_BGP_M2_PEER_ENTRY}.2" # idle(1), connect(2), active(3), opensent(4), openconfirm(5), established(6)
      OID_JNX_BGP_M2_PEER_CONFIGURED_VERSION     = "#{OID_JNX_BGP_M2_PEER_ENTRY}.4"
      OID_JNX_BGP_M2_PEER_NEGOTIATED_VERSION     = "#{OID_JNX_BGP_M2_PEER_ENTRY}.5"
      OID_JNX_BGP_M2_PEER_LOCAL_ADDR_TYPE        = "#{OID_JNX_BGP_M2_PEER_ENTRY}.6"
      OID_JNX_BGP_M2_PEER_LOCAL_ADDR             = "#{OID_JNX_BGP_M2_PEER_ENTRY}.7"
      OID_JNX_BGP_M2_PEER_LOCAL_AS               = "#{OID_JNX_BGP_M2_PEER_ENTRY}.9"
      OID_JNX_BGP_M2_PEER_REMOTE_ADDR_TYPE       = "#{OID_JNX_BGP_M2_PEER_ENTRY}.10"
      OID_JNX_BGP_M2_PEER_REMOTE_ADDR            = "#{OID_JNX_BGP_M2_PEER_ENTRY}.11"
      OID_JNX_BGP_M2_PEER_REMOTE_AS              = "#{OID_JNX_BGP_M2_PEER_ENTRY}.13"
      OID_JNX_BGP_M2_PEER_INDEX                  = "#{OID_JNX_BGP_M2_PEER_ENTRY}.14"  # Needed by the Counters Table

      OID_JNX_BGP_M2_PEER_COUNTERS               = "#{OID_JNX_BGP_M2_PEER}.6"
      OID_JNX_BGP_M2_PREFIX_COUNTERS_TABLE       = "#{OID_JNX_BGP_M2_PEER_COUNTERS}.2"
      OID_JNX_BGP_M2_PREFIX_COUNTERS_ENTRY       = "#{OID_JNX_BGP_M2_PREFIX_COUNTERS_TABLE}.1"
      OID_JNX_BGP_M2_PEER_IN_UPDATES             = "#{OID_JNX_BGP_M2_PREFIX_COUNTERS_ENTRY}.1"
      OID_JNX_BGP_M2_PEER_OUT_UPDATES            = "#{OID_JNX_BGP_M2_PREFIX_COUNTERS_ENTRY}.2"
      OID_JNX_BGP_M2_PEER_IN_TOTAL_MESSAGES      = "#{OID_JNX_BGP_M2_PREFIX_COUNTERS_ENTRY}.3"
      OID_JNX_BGP_M2_PEER_OUT_TOTAL_MESSAGES     = "#{OID_JNX_BGP_M2_PREFIX_COUNTERS_ENTRY}.4"
      OID_JNX_BGP_M2_PREFIX_IN_PREFIXES          = "#{OID_JNX_BGP_M2_PREFIX_COUNTERS_ENTRY}.7"
      OID_JNX_BGP_M2_PREFIX_IN_PREFIXES_ACCEPTED = "#{OID_JNX_BGP_M2_PREFIX_COUNTERS_ENTRY}.8"
      OID_JNX_BGP_M2_PREFIX_IN_PREFIXES_REJECTED = "#{OID_JNX_BGP_M2_PREFIX_COUNTERS_ENTRY}.9"
      OID_JNX_BGP_M2_PREFIX_OUT_PREFIXES         = "#{OID_JNX_BGP_M2_PREFIX_COUNTERS_ENTRY}.10"



      #
      # Init
      #
      def initialize(snmp = nil)
        if snmp
          @snmp_manager = snmp
        else
          @snmp_manager = nil
        end
      end



      #
      # Get the list of Routing Engines
      #
      #def get_routing_engines(snmp = nil)
      #  snmp = snmp_manager unless snmp

      #  if snmp
      #    @routing_engines.clear

      #    begin
      #      snmp.walk([ROUTING_ENGINES]) do |row|
      #        row.each do |vb|
      #          @routing_engines.push(vb.value)
      #        end
      #      end
      #    rescue Exception => e
      #      NewRelic::PlatformLogger.error("Unable to gather Routing Engines with error: #{e}")
      #    end

      #    NewRelic::PlatformLogger.debug("Device: Found #{@routing_engines.size} Routing Engines")
      #    return @routing_engines
      #  end
      #end



      #
      # Gather Memory related metrics and report them in bytes
      #
      #def get_memory_used(snmp = nil)
      #  snmp = snmp_manager unless snmp

      #  get_routing_engines(snmp) if @routing_engines.empty?
      #  res = gather_snmp_metrics_by_name("Memory/Used", @routing_engines, ROUTING_ENGINE_MEM_USED, snmp)
      #  NewRelic::PlatformLogger.debug("Device: Got #{res.size}/#{@routing_engines.size} Memory used metrics")
      #  return res
      #end

    end
  end
end

