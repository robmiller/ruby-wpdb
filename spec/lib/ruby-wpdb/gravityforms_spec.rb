require_relative '../../spec_helper'

module WPDB
  describe GravityForms do
    before do
      @form = GravityForms::Form.first
      @class_name = WPDB.camelize(@form.title).to_sym
    end

    it "fetches a form" do
      @form.id.should be > 0
    end

    it "associates leads with a form" do
      @form.leads.should_not be_empty
    end

    it "associates lead detail with a lead" do
      @form.leads.first.details.should_not be_empty
    end

    it "gets the name of a field" do
      @form.stub(:fields).and_return(sample_fields)
      @form.field_name(1).should == "First name"
      @form.field_name(2).should == "Last name"
    end

    it "lazily loads models for forms" do
      klass = GravityForms.const_get(@class_name)
      klass.should be_a(Class)
    end

    it "raises an error for forms that don't exist" do
      expect { GravityForms::AFormThatDoesNotExist }.to raise_error(/Form not found/)
    end
  end
end
