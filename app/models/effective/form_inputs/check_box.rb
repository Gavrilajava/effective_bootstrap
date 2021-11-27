# frozen_string_literal: true

module Effective
  module FormInputs
    class CheckBox < Effective::FormInput

      def to_html(&block)
        case layout
        when :horizontal
          build_wrapper do
            content_tag(:div, '', class: 'col-sm-2') + content_tag(:div, build_content(&block), class: 'col-sm-10')
          end
        else
          build_content(&block)
        end
      end

      def build_content(&block)
        build_check_box_wrap { build_input(&block) + build_label + build_feedback + build_hint }
      end

      def build_check_box_wrap(&block)
        if custom?
          content_tag(:div, yield, options[:wrapper])
        else
          content_tag(:div, yield, options[:wrapper])
        end
      end

      def wrapper_options
        if custom? && inline?
          { class: 'form-group custom-control custom-checkbox custom-control-inline' }
        elsif custom?
          { class: 'form-group custom-control custom-checkbox' }
        elsif inline?
          { class: 'form-check form-check-inline' }
        else
          { class: 'form-check' }
        end
      end

      def label_options
        if custom?
          { class: 'custom-control-label' }
        else
          { class: 'form-check-label' }
        end
      end

      def input_html_options
        if custom?
          { class: 'custom-control-input', id: unique_id }
        else
          { class: 'form-check-input', id: unique_id }
        end
      end

      private

      def inline? # default false
        return @inline unless @inline.nil?
        @inline = ((options[:input] || {}).delete(:inline) == true)
      end

      def custom? # default true
        return @custom unless @custom.nil?
        @custom = (options.delete(:custom) != false)
      end

    end
  end
end
