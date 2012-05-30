#!/bin/ruby

specs = ['sequel_model', 'dm_model', 'mm_model', 'tc_model', 'mongoid_model']
specs.each do |spec|
  spec_path = File.dirname(__FILE__) + "/unit/#{spec}_spec.rb"
  puts spec_path
  #@output = %x[rspec #{spec_path}]
  #puts @output
end
