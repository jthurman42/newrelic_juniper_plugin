require 'test_helper.rb'
class JuniperMonitorTest < Test::Unit::TestCase

  context "juniper_monitor" do

    setup do
      @verbose = $VERBOSE
      $VERBOSE = nil
      @file = File.expand_path("../../bin/juniper_monitor", __FILE__)
    end

    teardown do
      $VERBOSE = @verbose
    end

    should "show help" do
      `#{@file} -h` =~ /Usage:/
    end

    should "run" do
      ::ARGV = %w[run]
      NewRelic::JuniperPlugin.expects :run
      load @file
    end

    should "install" do
      ::ARGV = %w[install --license LICENSE_KEY]
      FileUtils.expects :mkdir_p
      File.expects :open
      load @file
    end
  end

end

