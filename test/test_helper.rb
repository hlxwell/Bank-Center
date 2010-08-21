ENV['RAILS_ENV'] = 'test'
ENV['RAILS_ROOT'] ||= File.dirname(__FILE__) + '/../../../..'

require 'rubygems'
require 'test/unit'
require 'active_support'
require File.expand_path(File.join(ENV['RAILS_ROOT'], 'config/environment.rb'))

def load_schema
  config = YAML::load(IO.read(File.dirname(__FILE__) + '/database.yml'))
  ActiveRecord::Base.logger = Logger.new(File.dirname(__FILE__) + "/debug.log")

  db_adapter = ENV['DB']

  # no db passed, try one of these fine config-free DBs before bombing.
  db_adapter ||= "mysql"

  if db_adapter.nil?
    raise "No DB Adapter selected. Pass the DB= option to pick one, or gem install mysql."
  end

  ActiveRecord::Base.establish_connection(config[db_adapter])
  load(File.dirname(__FILE__) + "/schema.rb")
end