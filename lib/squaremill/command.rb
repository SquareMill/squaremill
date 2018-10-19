require 'optparse'

module Squaremill
  class Command
    # Parse command line arguments and print out any errors
    def self.parse(args)
      options = {}
      initial_page = nil

      parser = OptionParser.new do |opts|
        opts.banner = "Usage: squaremill [options]\nExample: squaremill --config-file=some_dir/config.yml"

        opts.separator ""
        opts.separator "Specific options:"

        opts.on("-c", "--config [PATH]", "Use this value for the config file path") do |v|
          options[:output_dir] = v
        end

        opts.on("-d", "--output-dir [DIRECTORY]", "Write output to this directory, will override output_path value in config file") do |v|
          options[:output_dir] = v
        end

        opts.on("-v", "--verbose", "Run verbosely (sets log level to Logger::DEBUG)") do |v|
          options[:log_level] = Logger::DEBUG
        end

        opts.on("--log-level [NUMBER]", "Set log level 0 = most verbose to 4 = least verbose") do |v|
          options[:log_level] = v.to_i
        end

        opts.on("--log-file [PATH]", "Log file to write to") do |v|
          options[:logger] = Logger.new(v)
        end

        opts.on_tail("-h", "--help", "Show this message") do
          puts "test"
          puts opts
          exit
        end
      end

      begin      
        parser.parse!(args)
      rescue StandardError => e
        puts e
        puts parser
        exit(1)
      end

      return options
    end
  end
end


=begin

=end
