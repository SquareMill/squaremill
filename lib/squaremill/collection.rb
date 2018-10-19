require 'yaml'

module Squaremill
  class Collection
    attr_accessor :entries
    attr_accessor :name

    def initialize(name, config, options = {})
      @entries = {}
      @config = config
      @name = name
    end

    # Read all subdirectories and parse data into individual collections
    def self.read_all_collections(data_dir, config)
      data_dir = File.expand_path(data_dir)
      config.logger.info("Reading collections from #{data_dir}")

      @collections = {}

      collection_dirs = Dir.entries(data_dir).select do |entry|
        File.directory?(File.join(data_dir, entry)) && entry != '.' && entry != '..'
      end

      collection_dirs.each do |dir|
        collection_name = Collection.name_from_directory(dir, config)
        full_path = File.join(data_dir, dir)
        @collections[collection_name] = Collection.from_directory(full_path, collection_name, config)
      end

      @collections
    end

    def self.name_from_directory(dir, config)
      dir
    end

    def self.from_directory(dir, name, config, options = {})
      config.logger.info("Reading collection #{name} from #{dir}")

      collection = Collection.new(name, config, options)
      Dir[File.join(dir, "/*.yml")].each do |path|
        next if File.directory?(path)
        collection.read_entry_from_path(path)
      end

      config.logger.info("Read #{collection.entries.length} entries for #{collection.name} collection")
      collection
    end

    def read_entry_from_path(path)
      @config.logger.debug("Reading #{path} for collection #{self.name}")
      entry = YAML.load(File.open(path).read)
      @entries[entry["id"]] = entry
    end

    def [](id)
      @entries[id]
    end
  end
end