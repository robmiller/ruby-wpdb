require_relative 'test_helper'

describe WPDB::Option do
  before do
    @option = WPDB::Option.create(:option_name => 'test', :option_value => 'test')
  end

  it "creates options" do
    assert @option.option_id
  end

  it "enforces the uniqueness of option names" do
    assert_raises Sequel::UniqueConstraintViolation do
      WPDB::Option.create(:option_name => 'test', :option_value => 'test')
    end
  end

  it "has a shorthand for fetching options" do
    assert_equal 'test', WPDB::Option.get_option('test')
    assert_equal nil,    WPDB::Option.get_option('non-existent-key')
  end

  after do
    @option.destroy
  end
end
