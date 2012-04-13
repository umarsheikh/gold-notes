class labeledFormBuilder < ActionView::Helpers::FormBuilder

  # how to do it the metaprogramming way:
  %w[text_area password_field collection_select].each do |method_name|
    define_method(method_name) do |name, *args|
      @template.content_tag :div, class: 'field' do
        label(name) + @template.tag(:br) + super(name, *args) # check if the star belongs here
      end
    end
  end
  def text_field(name, *args)
    @template.content_tag :div, class: 'field' do
      label(name) + @template.tag(:br) + super
    end
  end
end

# now, use it loke so: form_form@product, builder: LabeledFormBuilder do |f| 
#                      # ...end

# using this text_field, you can replace:
# <div class="field"><label for="name"></label> <%= f.text_area 'name' %></div>
# with
# <%= f.text_area 'name'%>


