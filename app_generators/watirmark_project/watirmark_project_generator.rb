class WatirmarkProjectGenerator < RubiGen::Base
  default_options :author => nil
  attr_reader :name

  def initialize(args, runtime_options = {})
    super
    usage if args.empty?
    @name = File.basename(args[0])
    @destination_root = File.dirname(File.expand_path(args[0]))
    extract_options
  end

  def manifest
    record do |m|    
      create_directories(m)
      #gemfile and config
      m.template "gemfile.rb.erb", "#{@name}/Gemfile"
      m.template "example_config.rb.erb", "#{@name}/config.example"

      #rspec
      m.template "sample_spec.rb.erb", "#{@name}/spec/examples/sample_spec.rb"
      m.template "sample_spec_helper.rb.erb", "#{@name}/spec/spec_helper.rb"

      #cucumber
      m.template "sample_env.rb.erb", "#{@name}/features/support/env.rb"
      m.template "sample_feature.rb.erb", "#{@name}/features/examples/sample_feature.feature"
      m.template "sample_step_def.rb.erb", "#{@name}/features/step_definitions/sample_step_def.rb"
    end
  end

  def create_directories(m)
    [
      @name,
      "#{@name}/clo",
      "#{@name}/cla",
      "#{@name}/sf",
      "#{@name}/spec",
      "#{@name}/spec/examples",
      "#{@name}/features",
      "#{@name}/features/support",
      "#{@name}/features/examples",
      "#{@name}/features/step_definitions"
    ].each { |path| m.directory path }
  end
  
  protected

    def banner
      <<-EOS
      USAGE: #{spec.name} path/for/your/test/project project_name [options]
      EOS
    end

    def add_options!(opts)
      opts.separator ''
      opts.separator 'Options:'
      # For each option below, place the default
      # at the top of the file next to "default_options"
      # opts.on("-a", "--author=\"Your Name\"", String,
      #         "Some comment about this option",
      #         "Default: none") { |options[:author]| }
      opts.on("-v", "--version", "Show the #{File.basename($0)} version number and quit.")
    end

    def extract_options
      # for each option, extract it into a local variable (and create an "attr_reader :author" at the top)
      # Templates can access these value via the attr_reader-generated methods, but not the
      # raw instance variable value.
      # @author = options[:author]
    end
end