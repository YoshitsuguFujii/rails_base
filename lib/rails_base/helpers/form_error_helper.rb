module RailsBase::Helpers
  module FormErrorHelper
    ERROR_CSS = "has-error"
    HAS_ERROR_IF_STATEMENT_START  = "{{ if has_error }}"
    HAS_ERROR_IF_STATEMENT_END    = "{{/ endif }}"

    def render_error_message(instance, tag: :strong, class_option: "error-message", &block)
      error_messages = {}
      html = capture(&block)
      attributes_names = html.scan(/\{\{:(.*?)\}\}/).flatten
      attributes_names.each do |attr_name|
        error_messages.merge!({ attr_name => error_message(instance, attr_name) })
      end

      if_block = html.scan(/#{HAS_ERROR_IF_STATEMENT_START}.*?#{HAS_ERROR_IF_STATEMENT_END}/m).flatten.first
      if error_messages.values.any?(&:present?)
        html.gsub!(HAS_ERROR_IF_STATEMENT_START, "").gsub!(HAS_ERROR_IF_STATEMENT_END, "") if if_block.present?
        doc = Nokogiri::HTML::DocumentFragment.parse(html)
        procs = []

        error_messages.each do |attr_name, err_mes|
          id_name = "#{instance.class.model_name.param_key}_#{attr_name}"
          doc.css("input##{id_name}").each do |input|
            input['class'] += " #{ERROR_CSS}"
          end

          # クロージャ使って後で実行
          procs << Proc.new{|html| html.gsub!("{{:#{attr_name}}}", err_mes)}
        end
        html = doc.to_html
        procs.each{|proc| proc.call(html)}
      elsif if_block.present?
        html.gsub!(if_block,"")
      end

      html.html_safe
    end

    # block with has error statement
    def if_has_error?(&block)
      html = ""
      html << HAS_ERROR_IF_STATEMENT_START
      html << capture(&block)
      html << HAS_ERROR_IF_STATEMENT_END
      html.html_safe
    end

    def error_message(instance, attribute)
      full_messages = []

      attr_name = attribute.to_s.gsub('.', '_').humanize
      attr_name = instance.class.human_attribute_name(attribute, :default => attr_name)
      options = { :default => "%{attribute} %{message}", :attribute => attr_name }

      instance.errors[attribute.to_sym].uniq.each do |m|
        full_messages << "#{I18n.t(:"errors.format", options.merge(:message => m))}"
      end

      full_messages.join.html_safe
    end
  end
end
