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

  after do
    @option.destroy
  end
end
