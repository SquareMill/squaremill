require 'yaml'
require 'ostruct'

module Squaremill
  class Collection
    attr_accessor :entries
    attr_accessor :name

    def initialize(name, config, options = {})
      @entries = {}
      @config = config
      @name = name
    end

    def read_entry_from_path(path)
     # @config.logger.debug("Reading #{path} for collection #{self.name}")
      entry = YAML.load(File.open(path).read)
      @entries[entry["id"]] = entry
    end

    def where(opts = {})
      self.entries.find_all do |id, values|
        opts.all? {|name, value| values[name.to_s] == value }
      end
    end

    def [](id)
      @entries[id]
    end
  end
end