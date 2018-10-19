module Squaremill
  module Templates
    def self.from_path(path, config, options = {})
      @template_cache ||= {}
      options = options.dup
      options[:source_path] = path
      options[:format] = "erb" if options[:source_path] =~ /\.erb$/i
      options[:partial] = true if File.basename(options[:source_path])[0] == "_"
      @template_cache[path] = Template.new(File.read(path), config, options)
    end

    def self.read_all_templates(path, config)
      config.logger.info("Reading templates from #{config[:templates_path]}")

      Dir[File.join(config[:templates_path], "/**/*")].each do |file_path|
        next if File.directory?(file_path)
        self.from_path(file_path, config)
      end

      @template_cache
    end
  end
end