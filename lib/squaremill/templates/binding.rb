module Squaremill
  module Templates
    class Binding
      def initialize(config, collections, vars = {})
        @config = config
        @collections = collections

        vars.each do |key, value|
          self.define_singleton_method(key) { value }
        end if vars
      end

      def config
        @config
      end

      def collections
        @collections
      end

      def render(file_name, vars = {})
        path = File.join(config[:templates_path], file_name)
        template = Squaremill::Templates.from_path(path, config)
        template.render(collections: @collections, vars: vars)
      end

      def get_binding
        binding
      end
    end
  end
end