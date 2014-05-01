require_relative '../../spec_helper'

module WPDB
  describe Option do
    before do
      @option = Option.create(:option_name => 'test', :option_value => 'test')
    end

    it "creates options" do
      @option.option_id.should be > 0
    end

    it "enforces the uniqueness of option names" do
      expect {
        Option.create(:option_name => 'test', :option_value => 'test')
      }.to raise_error Sequel::UniqueConstraintViolation
    end

    it "has a shorthand for fetching options" do
      Option.get_option('test').should == 'test'
      Option.get_option('non-existent-key').should_not be
    end
  end
end
