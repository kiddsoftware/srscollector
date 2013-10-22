module ControllerSpecHelpers
  def sign_in(user)
    session[:user_id] = user.id
  end

  def sign_out(user)
    session[:user_id].should == user.id
    session[:user_id] = nil
  end

  def json
    @json ||= JSON.parse(response.body)
  end
end

module FeatureSpecHelpers
  def fill_in_html(field, options)
    with = options[:with]
    page.execute_script(<<"EOD")
(function () {
  var wysihtml5 = $(#{field.to_json}).data("wysihtml5");
  var editor = wysihtml5.editor;
  editor.setValue(#{with.to_json});
  editor.fire("change");
})();
EOD
  end

  def expect_html_to_match(field, regex)
    find(field, visible: false)
    timeout_at = Time.now + 3.seconds
    loop do
      actual = page.evaluate_script(<<"EOD")
(function () {
  var wysihtml5 = $(#{field.to_json}).data("wysihtml5");
  var editor = wysihtml5.editor;
  return editor.getValue();
})();
EOD
      break if actual =~ regex
      if Time.now > timeout_at
        fail("Expected #{regex.inspect}, got #{actual.inspect} in #{field}")
      end
    end
  end

  def select_all(field)
    page.execute_script(<<"EOD")
(function () {
  var wysihtml5 = $(#{field.to_json}).data("wysihtml5");
  var editor = wysihtml5.editor;
  var selection = editor.composer.selection;
  selection.selectNode(selection.doc.documentElement);
})();
EOD
  end

  def expect_nested_page(src)
    page.should have_xpath("//iframe[@src='#{src}']")
  end

end
