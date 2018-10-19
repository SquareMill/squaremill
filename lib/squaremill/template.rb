require 'pathname'
require 'yaml'
require 'erb'

module Squaremill
  class Template
    def self.from_file_path(path, config, options = {})
      options[:source_path] = path
      Template.new(File.read(path), config, options)
    end

    def initialize(text, config, options = {})
      @unprocessed_text = text
      @options = options
      @parsed_options = {}
      @output = nil
      @config = config

      self.extract_body_and_options
    end

    def output_path
      # If an otuput path is specified by this template then just use that
      path = @parsed_options[:output_path]

      # If an output path is not specified then use the location of this template
      # to figure out where to put the output. So for example:
      # app/something/template.html.erb
      # would go to 
      # output/something/template.html
      if path.nil? && @options[:source_path]
        absolute_path = Pathname.new(File.expand_path(@options[:source_path]))
        template_root = Pathname.new(File.expand_path(@config[:templates_path]))
        path = absolute_path.relative_path_from(template_root)
      end

      File.join(@config[:output_path], path.sub(/\.erb$/i,""))
     end

    def extract_body_and_options
      @config.logger.debug("Parsing template #{@options[:source_path]}") if @options[:source_path]

      # find any options at the top of the template and parse them into options
      options_text = @unprocessed_text.match(/^\s*---.*?---/im)
      @parsed_options = YAML.load(options_text[0]) if options_text

      @body_text = @unprocessed_text.sub(/^\s*---.*?---/im, "")

    #  @body_text, @parsed_options
    end

    def collections
      @collections
    end

    def render(config, options = {})
      raise "body_text is not set, cannot render template, was extract_options_and body called?" if @body_text.nil?
      @config.logger.debug("Processing template #{@options[:source_path]}") if @options[:source_path]
      template = ERB.new(@body_text)
      @collections = options[:collections]
      @config = config
      @output = template.result(binding)
    end
  end
end