class WdayInput < SimpleForm::Inputs::Base
  def input(wrapper_options)
    locale_key = input_html_options[:locale_key]  || "date.work_day_names"
    item_wrapper_class = options[:item_wrapper_class] || "mr5"
    @builder.collection_check_boxes(attribute_name, I18n.t(locale_key.to_sym).each_with_index.to_a, :last, :first,  item_wrapper_class: item_wrapper_class  )
  end
end
