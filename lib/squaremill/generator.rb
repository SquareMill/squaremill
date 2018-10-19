require 'yaml'

module Squaremill
  class Generator 
    def self.generate_new_project
      generate_data
      generate_views
      generate_config
      puts "Run the 'squaremill' command to see the output generated in deploy/"
    end

    def self.generate_config
      filename = "config.yml"
      if File.exists?(filename)
        puts "Not creating #{filename} already exists"
        return
      end
      puts "Creating #{filename}"

      File.open("config.yml", "wb") do |f|
        f << <<~EOS
          version: 0.1

          collections_path: "app/data/"
          templates_path: "app/views/"
          output_path: "deploy/"
        EOS
      end
    end

    def self.generate_data
      data_dir = "app/data/"
      if File.exists?(data_dir)
        puts "#{data_dir} directory already exists, not creating"
        return
      end

      puts "Creating #{data_dir} directory"
      FileUtils.mkdir_p(data_dir)

      example_dir = File.join(data_dir, "/example/")
      puts "Creating #{example_dir} collection"
      FileUtils.mkdir_p(example_dir)

      example_file = File.join(example_dir, "/test-entry.yml")
      puts "Creating entry in example collection #{example_file}"
      File.open(example_file, "wb") do |f|
        f << {"id" => "test-entry", "name" => "something"}.to_yaml
      end
    end

    def self.generate_views
      views_dir = "app/views/"
      if File.exists?(views_dir)
        puts "#{views_dir} already exists, not creating"
        return
      end
      puts "Creating #{views_dir} directory"
      FileUtils.mkdir(views_dir)
      
      example_path = File.join(views_dir, "/test-template.html.erb")
      puts "Creating test template #{example_path}"
      File.open(example_path, "wb") do |f|
        f << <<~EOS
        ---
        some_value: test
        ---
        <html>
        <head></head>
        <body>
          <h1>This is a test</h1>
          <% 3.times do |i| %>
            Looped <%= i %> times<br/>
          <% end %>
          This value comes from the example collection: <%= collections.example["test-entry"]["name"] %>
        </body>
        </html>
        EOS
      end
    end
  end
end