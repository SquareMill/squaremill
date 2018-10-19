module Squaremill
  class Static
    def initialize(command_line_opts)
      @command_line_opts = command_line_opts
    end

    def run
      @config = Squaremill::Config.new("config.yml")
      #config.set_command_line_opts(@command_line_opts)

      @collections = Squaremill::Collections.read_all_collections(@config[:collections_path] || "app/data/", @config)
      @templates = Squaremill::Templates.read_all_templates(@config[:templates_path] || "app/views/", @config)

      @config.logger.info("Cleaning #{@config[:output_path]}")
      FileUtils.rm_rf(@config[:output_path])

      @templates.each do |path, template|
        next if template.partial?
        template.write(collections: @collections)
      end
    end
  end
end