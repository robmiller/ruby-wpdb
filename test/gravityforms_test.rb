require_relative 'test_helper'

describe WPDB::GravityForms do
  before do
    @form = WPDB::GravityForms::Form.first
  end

  it "fetches a form" do
    assert @form.id
  end

  it "associates leads with a form" do
    assert @form.leads.length
  end

  it "associates lead detail with a lead" do
    assert @form.leads.first.details.length
  end
end
