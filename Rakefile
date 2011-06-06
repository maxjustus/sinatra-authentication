require 'rubygems'
require 'rake'
#require 'spec/rake/spectask'

begin
  require 'jeweler'
  
  Jeweler::Tasks.new do |gemspec|
    gemspec.name           = 'sinatra-authentication'
    gemspec.version        = '0.4.1'
    gemspec.description    = "Simple authentication plugin for sinatra."
    gemspec.summary        = "Simple authentication plugin for sinatra."
    gemspec.homepage       = "http://github.com/maxjustus/sinatra-authentication"
    gemspec.author         = "Max Justus Spransy"
    gemspec.email          = "maxjustus@gmail.com"
    gemspec.add_dependency "sinatra"
    gemspec.add_dependency "dm-core"
    gemspec.add_dependency "dm-migrations"
    gemspec.add_dependency "dm-validations"
    gemspec.add_dependency "dm-timestamps"
    gemspec.add_dependency "rufus-tokyo"
    gemspec.add_dependency "sinbook"
    gemspec.add_dependency "rack-flash"
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it first!"
end

Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each { |ext| load ext }

require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/activerecord_test.rb']
  t.verbose = true
end

namespace :ar do
  desc "create database"
  task :create_db, :config do |t, args|
    require 'yaml'
    config = YAML::load(File.open(args[:config]))

    require 'active_record'
    ActiveRecord::Base.establish_connection(config["db"])

    class CreateArUsers < ActiveRecord::Migration
      def self.up
        create_table :ar_users do |t|
          t.string :email
          t.string :hashed_password
          t.integer :permission_level
          t.string :fb_uid

          t.timestamps
        end

        add_index :ar_users, :email, :unique => true
      end

      def self.down
        remove_index :ar_users, :email
        drop_table :ar_users
      end
    end

    CreateArUsers.up
  end
end


#desc 'Run all specs'
#Spec::Rake::SpecTask.new('specs') do |t|
#  t.spec_files = FileList['spec/**/*.rb']
#end
