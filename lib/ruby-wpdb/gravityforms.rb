require 'php_serialize'
require 'json'
require 'csv'

module WPDB
  module GravityForms
    class Form < Sequel::Model(:"#{WPDB.prefix}rg_form")
      one_to_many :leads, :class => :'WPDB::GravityForms::Lead'

      one_to_one :meta, :class => :'WPDB::GravityForms::FormMeta'

      def fields
        begin
          display_meta = PHP.unserialize(meta.display_meta)
        rescue TypeError
          display_meta = JSON.parse(meta.display_meta)
        end
        display_meta['fields']
      end

      def field_name(number)
        number = number.to_f
        number = number.to_i if number.round == number
        number = number.to_s

        field = fields.find { |f| f['id'].to_s == number } || {}
        field['label']
      end

      def to_csv(io)
        io.puts(CSV.generate_line(leads.first.values.keys))

        leads.each do |lead|
          io.puts(lead.to_csv)
        end

        nil
      end

      class << self
        def from_title(title)
          self.first(:title => title)
        end
      end
    end

    class FormMeta < Sequel::Model(:"#{WPDB.prefix}rg_form_meta")
      one_to_one :form, :class => :'WPDB::GravityForms::Form'
    end

    class Lead < Sequel::Model(:"#{WPDB.prefix}rg_lead")
      many_to_one :form, :class => :'WPDB::GravityForms::Form'

      one_to_many :details, :class => :'WPDB::GravityForms::Detail'

      def values
        details.each_with_object({}) do |detail, values|
          key = form.field_name(detail.field_number) || detail.field_number
          values[key] = detail.value
        end
      end

      def to_csv
        CSV.generate_line(values.values)
      end
    end

    class Detail < Sequel::Model(:"#{WPDB.prefix}rg_lead_detail")
      many_to_one :lead, :class => :'WPDB::GravityForms::Lead'

      one_to_one :long_value, :key => :lead_detail_id, :class => :'WPDB::GravityForms::DetailLong'
    end

    class DetailLong < Sequel::Model(:"#{WPDB.prefix}rg_lead_detail_long")
      one_to_one :lead_detail, :class => :'WPDB::GravityForms::DetailLong'
    end

    # For each form that we have, define a class for accessing its
    # leads. So, if you have a form called "User Registration", we'll
    # define a class called UserRegistration, allowing you to do
    # things like:
    #
    # WPDB::GravityForms::UserRegistration.where(:date_registered => '2013-01-01').each do { |l| puts "#{l.first_name} #{l.last_name}" }
    #
    # All fields in the form are available as accessors.
    class ModelGenerator
      attr_reader :models

      def initialize(forms = nil)
        @forms = Array(forms) || Form.all
        @models = []
      end

      def generate
        @forms.each do |form|
          form_name = WPDB.camelize(form.title)
          form_class = build_class(form)

          @models << WPDB::GravityForms.const_set(form_name, form_class)
        end
      end

      private

      # Constructs a new Ruby class, inherited from Sequel::Model, that
      # will hold our model-like functionality. Sequel gives us most of
      # this for free, by virtue of defining a dataset.
      def build_class(form)
        @labels = []

        dataset = WPDB.db[:"#{WPDB.prefix}rg_lead___l"]
          .where(:"l__form_id" => form.id)

        dataset = join_fields(dataset, form.fields)
        dataset = dataset.select_all(:l)
        dataset = select_fields(dataset, form.fields)
        dataset = dataset.from_self

        Class.new(Sequel::Model) do
          set_dataset dataset
        end
      end

      def sanitise_label(original_label)
        @labels ||= []

        original_label = original_label.to_s
        return "" unless original_label.length > 0

        i = 1

        label = WPDB.underscoreize(original_label)
        while @labels.include?(label)
          label = WPDB.underscoreize(original_label + i.to_s)
          i += 1
        end

        @labels << label

        label
      end

      def ignored_fields
        ["html_block"]
      end

      def join_fields(dataset, fields)
        fields.each_with_index do |field, i|
          next unless field && field['label']
          next if ignored_fields.include?(field['label'])

          dataset = dataset.join_table(
            :left,
            :"#{WPDB.prefix}rg_lead_detail___ld#{i}",
            { :field_number => field['id'], :lead_id => :"l__id" }
          )
        end

        dataset
      end

      def select_fields(dataset, fields)
        fields.each_with_index do |field, i|
          next unless field && field['label']
          next if ignored_fields.include?(field['label'])

          field_name = sanitise_label(field['label'])

          next if field_name.empty?

          dataset = dataset.select_append(:"ld#{i}__value___#{field_name}")
        end

        dataset
      end
    end

    # When a request is made to, for example,
    # WPDB::GravityForms::SomeClass, this method will fire. If there's
    # a GravityForm whose title, when camelised, is "SomeClass", a model
    # will be created for that form.
    #
    # After the first time, the constant for that form will have been
    # created, and so this hook will no longer fire.
    def self.const_missing(name)
      Form.each do |form|
        if name.to_s == WPDB.camelize(form.title)
          ModelGenerator.new(form).generate
          return WPDB::GravityForms.const_get(name)
        end
      end

      raise "Form not found: #{name}"
    end
  end

  # Given a string, will convert it to a camel case suitable for use in
  # a Ruby constant (which means no non-alphanumeric characters and no
  # leading numbers).
  def self.camelize(string)
    string.gsub(/[^a-z0-9 ]/i, '')
      .gsub(/^[0-9]+/, '')
      .split(/\s+/)
      .map { |t| t.strip.capitalize }
      .join('')
  end

  # Given a string, will convert it an_underscored_value suitable for
  # use in a Ruby variable name/symbol.
  def self.underscoreize(string)
    string.downcase
      .gsub(/ +/, ' ')
      .gsub(' ', '_')
      .gsub(/[^a-z0-9_]/, '')
  end
end
