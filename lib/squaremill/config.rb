require 'logger'
require 'yaml'

module Squaremill
  class Config
    attr_reader :config
    attr_reader :path

    def initialize(path = nil)
      if path
        self.logger.info("Reading configuration from #{path}")
        @path = path
        @config = parse_config_file(@path)
      end
    end

    def logger
     if @logger.nil?
        @logger = Logger.new(STDOUT)
        @logger.formatter = proc do |severity, datetime, progname, msg|
           "#{severity}: #{msg}\n"
        end
      end
      @logger
    end

    def parse_config_file(path)
      @config = YAML.load(File.read(path))
    end

    def [](key)
      self.config[key.to_s]
    end
  end
end