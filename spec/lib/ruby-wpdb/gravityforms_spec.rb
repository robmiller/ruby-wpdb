require_relative '../../spec_helper'

module WPDB
  describe GravityForms do
    let(:sample_fields) {
      [
        { "id" => 1, "label" => "First name" },
        { "id" => 2, "label" => "Last name" }
      ]
    }

    let(:sample_details) {
      [
        GravityForms::Detail.new(lead_id: 1, form_id: 1, field_number: 1, value: "Rob"),
        GravityForms::Detail.new(lead_id: 1, form_id: 1, field_number: 2, value: "Miller")
      ]
    }

    let(:sample_leads) {
      [
        GravityForms::Lead.new
      ]
    }

    before(:each) do
      @form = GravityForms::Form.first
      @class_name = WPDB.camelize(@form.title).to_sym

      sample_leads.each do |lead|
        lead.stub(:details).and_return(sample_details)
        lead.stub(:form).and_return(@form)
        lead.stub(:values).and_return({"First name" => "Rob", "Last name" => "Miller"})
      end
    end

    it "fetches a form" do
      @form.id.should be > 0
    end

    it "fetches forms by title" do
      GravityForms::Form.from_title(@form.title).id.should == @form.id
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

    it "fetches the details of a lead as a hash" do
      fields = @form.leads.first.values
      @form.leads.first.details.each do |detail|
        fields.values.should include(detail.value)
      end
    end

    it "generates a CSV" do
      @form.stub(:fields).and_return(sample_fields)
      @form.stub(:leads).and_return(sample_leads)

      io = StringIO.new
      @form.to_csv(io)

      io.string.should == "First name,Last name\nRob,Miller\n"
    end

    it "generates unique names for labels" do
      generator = GravityForms::ModelGenerator.new
      generator.send(:sanitise_label, "Hello world").should == "hello_world"
      generator.send(:sanitise_label, "Hello world").should == "hello_world1"
    end

    it "lazily loads models for forms" do
      klass = GravityForms.const_get(@class_name)
      klass.should be_a(Class)
    end

    it "dynamically loads forms if they aren't loaded when requested" do
      GravityForms.send(:remove_const, @class_name)
      klass = GravityForms.const_get(@class_name)
      klass.should be_a(Class)
    end

    it "raises an error for forms that don't exist" do
      expect { GravityForms::AFormThatDoesNotExist }.to raise_error(/Form not found/)
    end
  end
end
