module Squaremill
  module Collections
    # Read all subdirectories and parse data into individual collections
    def self.read_all_collections(data_dir, config)
      data_dir = File.expand_path(data_dir)
      config.logger.info("Reading collections from #{data_dir}")

      @collections = {}

      collection_dirs = Dir.entries(data_dir).select do |entry|
        File.directory?(File.join(data_dir, entry)) && entry != '.' && entry != '..'
      end

      collection_dirs.each do |dir|
        collection_name = self.name_from_directory(dir, config)
        full_path = File.join(data_dir, dir)
        @collections[collection_name] = self.from_directory(full_path, collection_name, config)
      end

      OpenStruct.new(@collections)
    end

    def self.from_directory(dir, name, config, options = {})
      config.logger.info("Reading collection #{name} from #{dir}")

      collection = Collection.new(name, config, options)
      Dir[File.join(dir, "/*.yml")].each do |path|
        next if File.directory?(path)
        collection.read_entry_from_path(path)
      end
      Dir[File.join(dir, "/*.md")].each do |path|
        next if File.directory?(path)
        collection.read_entry_from_path(path)
      end

      config.logger.info("Read #{collection.entries.length} entries for #{collection.name} collection")
      collection
    end


    def self.name_from_directory(dir, config)
      dir
    end
  end
end