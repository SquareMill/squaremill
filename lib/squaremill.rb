require 'pry-byebug'

require_relative "squaremill/version"
require_relative "squaremill/config"
require_relative "squaremill/static"
require_relative "squaremill/collections"
require_relative "squaremill/collections/collection"
require_relative "squaremill/templates"
require_relative "squaremill/templates/template"
require_relative "squaremill/templates/binding"

Dir["app/helpers/**/*.rb"].each do |helper|
  require File.join(Dir.pwd, helper)
end

module Squaremill
end
