require 'spec_helper'

module Nombus
  describe Configurator do
    # Get the path to the config file above the current directory
    let(:rc_path) { File.join NOMBUS_DIR, 'nombus.rc.yml' }
    let(:yaml_config) { YAML::load( File.open(rc_path) ) }
    let(:config)  { Configurator.new(yaml_config) }
    let(:column_minus_1) { yaml_config['column'].to_i - 1 }
    
    describe "#column_error" do
      it "returns an error if column is not a number" do
        config.column_error('non-number').should include('not a valid number')
      end
      
      it "returns Nil if there was no error" do
        config.column_error('1').should be_nil
      end
    end
    
    describe "#column_index" do
      it "returns an Integer" do
        config.column_index.should be_an_integer
      end
      
      it "returns a number that is 1 less that what was initially given" do
        config.column_index.should == column_minus_1
      end
    end
    
    describe "#separator_error" do
      it "returns an error message if the separator is a whitespace character" do
        config.separator_error(' ').should include("Separator can't be a literal whitspace character.")
      end
      
      it "returns Nil if there was no error" do
        config.separator_error(',').should be_nil
      end
    end
    
    describe "#get_separator" do
      it 'returns a tab chararacter if the word "tab" is in the input' do
        config.get_separator('tab').should == "\t"
      end
    end
  end
end