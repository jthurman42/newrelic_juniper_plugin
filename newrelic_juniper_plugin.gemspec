## This is the rakegem gemspec template. Make sure you read and understand
## all of the comments. Some sections require modification, and others can
## be deleted if you don't need them. Once you understand the contents of
## this file, feel free to delete any comments that begin with two hash marks.
## You can find comprehensive Gem::Specification documentation, at
## http://docs.rubygems.org/read/chapter/20
Gem::Specification.new do |s|
  s.specification_version = 2 if s.respond_to? :specification_version=
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.rubygems_version = '1.3.5'

  ## Leave these as is they will be modified for you by the rake gemspec task.
  ## If your rubyforge_project name is different, then edit it and comment out
  ## the sub! line in the Rakefile
  s.name              = 'newrelic_juniper_plugin'
  s.version           = '0.0.1'
  s.date              = '2013-12-06'
  s.rubyforge_project = 'newrelic_juniper_plugin'

  ## Make sure your summary is short. The description may be as long
  ## as you like.
  s.summary     = "New Relic Juniper plugin"
  s.description = <<-EOF
This is the New Relic plugin for gathering Networking statistics from Juniper devices developed by Jonathan Thurman
  EOF

  ## List the primary authors. If there are a bunch of authors, it's probably
  ## better to set the email to an email list or something. If you don't have
  ## a custom homepage, consider using your GitHub URL or the like.
  s.authors  = ["Jonathan Thurman"]
  s.email    = 'dev@thurmantech.com'
  s.homepage = 'http://thurmantech.com'

  ## This gets added to the $LOAD_PATH so that 'lib/NAME.rb' can be required as
  ## require 'NAME.rb' or'/lib/NAME/file.rb' can be as require 'NAME/file.rb'
  s.require_paths = %w[lib]

  ## This sections is only necessary if you have C extensions.
  # s.require_paths << 'ext'
  # s.extensions = %w[ext/extconf.rb]

  ## If your gem includes any executables, list them here.
  s.executables = ["juniper_monitor"]

  ## Specify any RDoc options here. You'll want to add your README and
  ## LICENSE files to the extra_rdoc_files list.
  s.rdoc_options = ["--charset=UTF-8",
                    "--main", "README.rdoc"]
  s.extra_rdoc_files = %w[README.rdoc LICENSE CHANGES]

  s.add_dependency('bigdecimal', '~> 1.1.0')
  s.add_dependency('newrelic_plugin', '~> 1.3.0')
  s.add_dependency('snmp', '~> 1.1.1')

  s.post_install_message = <<-EOF
To get started with this plugin, create a working directory and do
  juniper_monitor -h
to find out how to install and run the plugin agent.
  EOF

  ## Leave this section as-is. It will be automatically generated from the
  ## contents of your Git repository via the gemspec task. DO NOT REMOVE
  ## THE MANIFEST COMMENTS, they are used as delimiters by the task.
  # = MANIFEST =
  s.files = %w[
    CHANGES
    Gemfile
    LICENSE
    README.rdoc
    Rakefile
    bin/juniper_monitor
    config/newrelic_plugin.yml
    lib/newrelic_juniper_plugin.rb
    lib/newrelic_juniper_plugin/agent.rb
    lib/newrelic_juniper_plugin/device.rb
    lib/newrelic_juniper_plugin/interface.rb
    lib/newrelic_juniper_plugin/util.rb
    newrelic_juniper_plugin.gemspec
    test/juniper_monitor_test.rb
    test/plugin_test.rb
    test/test_helper.rb
  ]
  # = MANIFEST =

  ## Test files will be grabbed from the file list. Make sure the path glob
  ## matches what you actually use.
  s.test_files = s.files.select { |path| path =~ /^test\/test_.*\.rb/ }
end
