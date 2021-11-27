# frozen_string_literal: true

module Effective
  module FormInputs
    class RemoteLinkTo < Submit

      def build_input(&block)
        tags = [
          icon('check', style: 'display: none;'),
          icon('x', style: 'display: none;'),
          icon('spinner'),
          (block_given? ? capture(&block) : content_tag(:a, name, options[:input]))
        ]

        (left? ? tags.reverse.join : tags.join).html_safe
      end

      def input_html_options
        { class: '', rel: 'nofollow', data: { method: :post, remote: true, confirm: confirm } }
      end

      def border?
        false
      end

      def confirm
        (options.delete(:confirm) || "#{name} to<br>#{object}?").html_safe
      end

    end
  end
end
