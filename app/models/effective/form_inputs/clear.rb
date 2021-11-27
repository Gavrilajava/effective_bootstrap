# frozen_string_literal: true

module Effective
  module FormInputs
    class Clear < Effective::FormInput

      def to_html(&block)
        content_tag(:button, options[:input]) do
          icon_name.present? ? (icon(icon_name) + name) : name
        end
      end

      def input_html_options
        { class: 'btn btn-primary', type: 'clear', id: tag_id }
      end

      def icon_name
        return @icon unless @icon.nil?
        @icon = options[:input].delete(:icon) || ''.html_safe
      end

    end
  end
end
