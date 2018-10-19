require 'pathname'
require 'yaml'
require 'erb'

module Squaremill
  module Templates
    class Template
      def initialize(text, config, options = {})
        @unprocessed_text = text
        @options = options.dup
        @config = config

        self.extract_body_and_options
      end

      def write(options = {})
        output = self.render(collections: options[:collections])

        path = self.output_path
        @config.logger.info("Writing template to #{path}")
        FileUtils.mkdir_p(File.dirname(path)) if !File.exists?(File.dirname(path))
        File.open(path, "wb") {|f| f << output }
      end

      def output_path
        # If an otuput path is specified by this template then just use that
        path = @options[:output_path]

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
        if options_text
          parsed_options = YAML.load(options_text[0])
          @options.merge!(parsed_options)
        end

        @body_text = @unprocessed_text.sub(/^\s*---.*?---/im, "")
      end

      def partial?
        @options[:partial]
      end

      def render(render_opts = {})
        raise "body_text is not set, cannot render template, was extract_options_and body called?" if @body_text.nil?
        @config.logger.debug("Processing #{@options[:format] || "text"} template #{@options[:source_path]}") if @options[:source_path]

        if @options[:format] == "erb"
          template = ERB.new(@body_text)
          template_binding = Squaremill::Templates::Binding.new(@config, render_opts.merge(helpers: @options["helpers"]))

          @output = template.result(template_binding.get_binding {|*args| template_binding.handle_yield(args)} )

          if @options["layout"]
            path = File.join(@config[:templates_path], @options["layout"])
            template = Squaremill::Templates.from_path(path, @config)
            @output = template.render(collections: @collections, content: @output)
          end

          @output
        else
          @output = @body_text
        end
      end
    end
  end
end