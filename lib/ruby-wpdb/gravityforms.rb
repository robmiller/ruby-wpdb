require 'php_serialize'
require 'csv'

module WPDB
  module GravityForms
    class Form < Sequel::Model(:"#{WPDB.prefix}rg_form")
      one_to_many :leads, :class => :'WPDB::GravityForms::Lead'

      one_to_one :meta, :class => :'WPDB::GravityForms::FormMeta'

      def fields
        display_meta = PHP.unserialize(meta.display_meta)
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
  end
end
