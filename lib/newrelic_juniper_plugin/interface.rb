#!/usr/bin/env ruby

require 'newrelic_plugin'
require 'snmp'

module NewRelic
  module JuniperPlugin

    class Interface
      attr_accessor :snmp_manager, :interface_indexes, :interface_names

      # Create the OIDs
      OID_IF_MIB                   = "1.3.6.1.2.1.31"
      OID_IF_X_ENTRY               = "#{OID_IF_MIB}.1.1.1"
      OID_INTERFACE_NAMES          = "#{OID_IF_X_ENTRY}.1"
      OID_IF_HC_IN_OCTETS          = "#{OID_IF_X_ENTRY}.6"
      OID_IF_HC_IN_UCAST_PKTS      = "#{OID_IF_X_ENTRY}.7"
      OID_IF_HC_IN_MULTICAST_PKTS  = "#{OID_IF_X_ENTRY}.8"
      OID_IF_HC_IN_BROADCAST_PKTS  = "#{OID_IF_X_ENTRY}.9"
      OID_IF_HC_OUT_OCTETS         = "#{OID_IF_X_ENTRY}.10"
      OID_IF_HC_OUT_UCAST_PKTS     = "#{OID_IF_X_ENTRY}.11"
      OID_IF_HC_OUT_MULTICAST_PKTS = "#{OID_IF_X_ENTRY}.12"
      OID_IF_HC_OUT_BROADCAST_PKTS = "#{OID_IF_X_ENTRY}.13"

      #
      # Init
      #
      def initialize(interface_indexes, snmp = nil)
        @interface_indexes = interface_indexes
        @interface_names = [ ]

        if snmp
          @snmp_manager = snmp
        else
          @snmp_manager = nil
        end
      end


      #
      # Get the list of Interfaces
      #
      def get_names(snmp = nil)
        snmp = snmp_manager unless snmp
        oids = [ ]

        if snmp
          @interface_names.clear

          @interface_indexes.each do |index|
            oids.push("#{OID_INTERFACE_NAMES}.#{index}")
          end

          @interface_names = gather_snmp_metrics_array(oids, snmp)

          NewRelic::PlatformLogger.debug("Interface: Found #{@interface_names.size} interface names")
          return @interface_names
        end
      end


      def get_in_octets(snmp = nil)
        snmp    = snmp_manager unless snmp
        oids    = [ ]
        metrics = { }
        index   = 0

        get_names(snmp) if @interface_names.empty?

        # Generate the OIDs
        @interface_indexes.each do |index|
          oids.push("#{OID_IF_HC_IN_OCTETS}.#{index}")
        end

        res = gather_snmp_metrics_array(oids, snmp)

        @interface_names.each do |name|
          metrics["Interface/Traffic/Inbound/#{name}"] = res[index].to_i
          index += 1
        end
        metrics = metrics.each_key { |n| metrics[n] *= 8 }

        NewRelic::PlatformLogger.debug("Device: Got #{metrics.size}/#{@interface_names.size} In Octet metrics")
        return metrics
      end

      def get_out_octets(snmp = nil)
        snmp    = snmp_manager unless snmp
        oids    = [ ]
        metrics = { }
        index   = 0

        get_names(snmp) if @interface_names.empty?

        # Generate the OIDs
        @interface_indexes.each do |index|
          oids.push("#{OID_IF_HC_OUT_OCTETS}.#{index}")
        end

        res = gather_snmp_metrics_array(oids, snmp)

        @interface_names.each do |name|
          metrics["Interface/Traffic/Outbound/#{name}"] = res[index].to_i
          index += 1
        end
        metrics = metrics.each_key { |n| metrics[n] *= 8 }

        NewRelic::PlatformLogger.debug("Device: Got #{metrics.size}/#{@interface_names.size} Out Octet metrics")
        return metrics
      end



      def get_in_ucast_pkts(snmp = nil)
        snmp    = snmp_manager unless snmp
        oids    = [ ]
        metrics = { }
        index   = 0

        get_names(snmp) if @interface_names.empty?

        # Generate the OIDs
        @interface_indexes.each do |index|
          oids.push("#{OID_IF_HC_IN_UCAST_PKTS}.#{index}")
        end

        res = gather_snmp_metrics_array(oids, snmp)

        @interface_names.each do |name|
          metrics["Interface/Packets/Unicast/Inbound/#{name}"] = res[index].to_i
          index += 1
        end
        metrics = metrics.each_key { |n| metrics[n] *= 8 }

        NewRelic::PlatformLogger.debug("Device: Got #{metrics.size}/#{@interface_names.size} In Unicast Packet metrics")
        return metrics
      end

      def get_in_multicast_pkts(snmp = nil)
        snmp    = snmp_manager unless snmp
        oids    = [ ]
        metrics = { }
        index   = 0

        get_names(snmp) if @interface_names.empty?

        # Generate the OIDs
        @interface_indexes.each do |index|
          oids.push("#{OID_IF_HC_IN_MULTICAST_PKTS}.#{index}")
        end

        res = gather_snmp_metrics_array(oids, snmp)

        @interface_names.each do |name|
          metrics["Interface/Packets/Multicast/Inbound/#{name}"] = res[index].to_i
          index += 1
        end
        metrics = metrics.each_key { |n| metrics[n] *= 8 }

        NewRelic::PlatformLogger.debug("Device: Got #{metrics.size}/#{@interface_names.size} In Multicast Packet metrics")
        return metrics
      end

      def get_in_broadcast_pkts(snmp = nil)
        snmp    = snmp_manager unless snmp
        oids    = [ ]
        metrics = { }
        index   = 0

        get_names(snmp) if @interface_names.empty?

        # Generate the OIDs
        @interface_indexes.each do |index|
          oids.push("#{OID_IF_HC_IN_BROADCAST_PKTS}.#{index}")
        end

        res = gather_snmp_metrics_array(oids, snmp)

        @interface_names.each do |name|
          metrics["Interface/Packets/Broadcast/Inbound/#{name}"] = res[index].to_i
          index += 1
        end
        metrics = metrics.each_key { |n| metrics[n] *= 8 }

        NewRelic::PlatformLogger.debug("Device: Got #{metrics.size}/#{@interface_names.size} In Broadcast Packet metrics")
        return metrics
      end



      def get_out_ucast_pkts(snmp = nil)
        snmp    = snmp_manager unless snmp
        oids    = [ ]
        metrics = { }
        index   = 0

        get_names(snmp) if @interface_names.empty?

        # Generate the OIDs
        @interface_indexes.each do |index|
          oids.push("#{OID_IF_HC_OUT_UCAST_PKTS}.#{index}")
        end

        res = gather_snmp_metrics_array(oids, snmp)

        @interface_names.each do |name|
          metrics["Interface/Packets/Unicast/Outbound/#{name}"] = res[index].to_i
          index += 1
        end
        metrics = metrics.each_key { |n| metrics[n] *= 8 }

        NewRelic::PlatformLogger.debug("Device: Got #{metrics.size}/#{@interface_names.size} Out Unicast Packet metrics")
        return metrics
      end

      def get_out_multicast_pkts(snmp = nil)
        snmp    = snmp_manager unless snmp
        oids    = [ ]
        metrics = { }
        index   = 0

        get_names(snmp) if @interface_names.empty?

        # Generate the OIDs
        @interface_indexes.each do |index|
          oids.push("#{OID_IF_HC_OUT_MULTICAST_PKTS}.#{index}")
        end

        res = gather_snmp_metrics_array(oids, snmp)

        @interface_names.each do |name|
          metrics["Interface/Packets/Multicast/Outbound/#{name}"] = res[index].to_i
          index += 1
        end
        metrics = metrics.each_key { |n| metrics[n] *= 8 }

        NewRelic::PlatformLogger.debug("Device: Got #{metrics.size}/#{@interface_names.size} Out Multicast Packet metrics")
        return metrics
      end

      def get_out_broadcast_pkts(snmp = nil)
        snmp    = snmp_manager unless snmp
        oids    = [ ]
        metrics = { }
        index   = 0

        get_names(snmp) if @interface_names.empty?

        # Generate the OIDs
        @interface_indexes.each do |index|
          oids.push("#{OID_IF_HC_OUT_BROADCAST_PKTS}.#{index}")
        end

        res = gather_snmp_metrics_array(oids, snmp)

        @interface_names.each do |name|
          metrics["Interface/Packets/Broadcast/Outbound/#{name}"] = res[index].to_i
          index += 1
        end
        metrics = metrics.each_key { |n| metrics[n] *= 8 }

        NewRelic::PlatformLogger.debug("Device: Got #{metrics.size}/#{@interface_names.size} Out Broadcast Packet metrics")
        return metrics
      end

    end
  end
end

