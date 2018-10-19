require 'fileutils'

module Squaremill
  class Static
    def initialize(command_line_opts)
      @template_cache = {}
      @command_line_opts = command_line_opts
    end

    def run
      @config = Squaremill::Config.new("config.yml")
      #config.set_command_line_opts(@command_line_opts)

      @collections = Squaremill::Collection.read_all_collections(@config[:collections_path] || "app/data/", @config)

      template_path = @config[:templates_path] || "app/views/"

      @config.logger.info("Reading templates from #{template_path}")

      Dir[File.join(template_path, "/**/*.html.erb")].each do |file_path|
        template = parse_template(file_path)
        write_output(template)
      end
    end
  
    def parse_template(file_path)
      return @template_cache[file_path] if @template_cache.has_key?(file_path)
      @template_cache[file_path] = Template.from_file_path(file_path, @config)
    end

    def write_output(template)
      path = template.output_path
      output = template.render(@config, collections: @collections)

      @config.logger.info("Writing template to #{path}")

      if !File.exists?(@config[:output_path])
        FileUtils.mkdir_p(@config[:output_path])
      end
      path = template.output_path
      dir = File.dirname(path)
      FileUtils.mkdir_p(dir) if !File.exists?(dir)

      File.open(path, "wb") do |f|
        f << output
      end
    end
  end
end