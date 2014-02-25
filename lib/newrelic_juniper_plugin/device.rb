#!/usr/bin/env ruby

require 'newrelic_plugin'
require 'snmp'

module NewRelic
  module JuniperPlugin

    class Device
      attr_accessor :snmp_manager, :routing_engines

      # Create the OIDs
      OID_JUNIPER_MIB          = "1.3.6.1.4.1.2636"
      OID_JNX_BOX_ANATOMY      = "#{OID_JUNIPER_MIB}.3.1"

      OID_JNX_BOX_DESCR        = "#{OID_JNX_BOX_ANATOMY}.2"
      OID_JNX_BOX_SERIAL_NO    = "#{OID_JNX_BOX_ANATOMY}.3"

      OID_JNX_OPERATING_TABLE  = "#{OID_JNX_BOX_ANATOMY}.13"
      OID_JNX_OPERATING_ENTRY  = "#{OID_JNX_OPERATING_TABLE}.1"

      OID_JNX_OPERATING_DESCR  = "#{OID_JNX_OPERATING_ENTRY}.5"  # Name of item
      OID_JNX_OPERATING_TEMP   = "#{OID_JNX_OPERATING_ENTRY}.7"
      OID_JNX_OPERATING_CPU    = "#{OID_JNX_OPERATING_ENTRY}.8"
      OID_JNX_OPERATING_BUFFER = "#{OID_JNX_OPERATING_ENTRY}.11"
      OID_JNX_OPERATING_MEMORY = "#{OID_JNX_OPERATING_ENTRY}.15"  # Max Memory

      # The routing engines are .9, and what we care about
      ROUTING_ENGINES          = "#{OID_JNX_OPERATING_DESCR}.9"
      ROUTING_ENGINE_CPU       = "#{OID_JNX_OPERATING_CPU}.9"
      ROUTING_ENGINE_MEM_USED  = "#{OID_JNX_OPERATING_BUFFER}.9"
      ROUTING_ENGINE_MEM_TOTAL = "#{OID_JNX_OPERATING_MEMORY}.9"
      ROUTING_ENGINE_TEMP      = "#{OID_JNX_OPERATING_TEMP}.9"

      #
      # Init
      #
      def initialize(snmp = nil)
        @routing_engines = [ ]

        if snmp
          @snmp_manager = snmp
        else
          @snmp_manager = nil
        end
      end

      #
      # Gather Version information
      #
      #def get_version(snmp = nil)
      #  version = "Unknown!"
      #  snmp    = snmp_manager unless snmp

      #  if snmp
      #    res = gather_snmp_metrics_array([OID_SYS_PRODUCT_VERSION, OID_SYS_PRODUCT_BUILD], snmp)

      #    version = "#{res[0]}.#{res[1]}" unless res.empty?
      #  end

      #  return version
      #end



      #
      # Get the list of Routing Engines
      #
      def get_routing_engines(snmp = nil)
        snmp = snmp_manager unless snmp

        if snmp
          @routing_engines.clear

          begin
            snmp.walk([ROUTING_ENGINES]) do |row|
              row.each do |vb|
                @routing_engines.push(vb.value)
              end
            end
          rescue Exception => e
            NewRelic::PlatformLogger.error("Unable to gather Routing Engines with error: #{e}")
          end

          NewRelic::PlatformLogger.debug("Device: Found #{@routing_engines.size} Routing Engines")
          return @routing_engines
        end
      end



      #
      # Gather CPU Related metrics and report them in %
      #
      def get_cpu(snmp = nil)
        snmp = snmp_manager unless snmp

        get_routing_engines(snmp) if @routing_engines.empty?
        res = gather_snmp_metrics_by_name("CPU", @routing_engines, ROUTING_ENGINE_CPU, snmp)
        NewRelic::PlatformLogger.debug("Device: Got #{res.size}/#{@routing_engines.size} CPU metrics")
        return res
      end



      #
      # Gather Memory related metrics and report them in bytes
      #
      def get_memory_used(snmp = nil)
        snmp = snmp_manager unless snmp

        get_routing_engines(snmp) if @routing_engines.empty?
        res = gather_snmp_metrics_by_name("Memory/Used", @routing_engines, ROUTING_ENGINE_MEM_USED, snmp)
        NewRelic::PlatformLogger.debug("Device: Got #{res.size}/#{@routing_engines.size} Memory used metrics")
        return res
      end

      def get_memory_total(snmp = nil)
        snmp = snmp_manager unless snmp

        get_routing_engines(snmp) if @routing_engines.empty?
        res = gather_snmp_metrics_by_name("Memory/Total", @routing_engines, ROUTING_ENGINE_MEM_TOTAL, snmp)
        NewRelic::PlatformLogger.debug("Device: Got #{res.size}/#{@routing_engines.size} Memory total metrics")
        return res
      end



      #
      # Gather routing engine temps (degrees C)
      #
      def get_temp(snmp = nil)
        snmp = snmp_manager unless snmp

        get_routing_engines(snmp) if @routing_engines.empty?
        res = gather_snmp_metrics_by_name("Temp", @routing_engines, ROUTING_ENGINE_TEMP, snmp)
        NewRelic::PlatformLogger.debug("Device: Got #{res.size}/#{@routing_engines.size} Temperature metrics")
        return res
      end

    end
  end
end

