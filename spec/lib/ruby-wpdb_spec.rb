require_relative "../spec_helper"

describe WPDB do
  describe ".underscoreize" do
    it "converts spaces to underscores" do
      WPDB.underscoreize("foo bar").should == "foo_bar"
    end

    it "copes with multiple spaces" do
      WPDB.underscoreize("foo          bar").should == "foo_bar"
    end

    it "removes special characters" do
      WPDB.underscoreize("foo!@£$%^&*()-+[]{};:'\"\| bar").should == "foo_bar"
    end

    it "retains letters, numbers, and underscores" do
      WPDB.underscoreize("foo123_456bar").should == "foo123_456bar"
    end

    it "forces lower-case" do
      WPDB.underscoreize("FOO").should == "foo"
    end
  end

  describe ".camelize" do
    it "strips anything but letters, numbers, and spaces" do
      WPDB.camelize("foo123!@£$%^&*()-+[]{};:'\"\| bar").should == "Foo123Bar"
    end

    it "strips leading numbers but retains others" do
      WPDB.camelize("1 foo 1 bar").should == "Foo1Bar"
    end

    it "collapses multiple spaces" do
      WPDB.camelize("foo      bar").should == "FooBar"
    end

    it "copes with leading spaces" do
      WPDB.camelize("   foo bar").should == "FooBar"
    end

    it "copes with trailing spaces" do
      WPDB.camelize("foo bar    ").should == "FooBar"
    end

    it "converts all-uppercase to camelcase" do
      WPDB.camelize("FOO BAR").should == "FooBar"
    end
  end
end

