module GlobalSpecHelpers
  # Mock up an external web server that serves an image.  Returns the URL of
  # the image.
  def stub_image_url
    image_url = "http://www.example.com/image.png"
    image_path = File.expand_path('../../data/image.png', __FILE__)
    stub_request(:get, image_url).
      to_return(body: File.new(image_path),
                headers: { 'Content-Type' => 'image/png' })
    image_url
  end
end

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
  # We have some asynchronous DOM requests that occasionally take a long
  # time, but we can't finish a scenario until they're done using our web
  # server, or we'll get weird database state.  We can call this at the end
  # of a scenario if we want to rule out this problem and focus on other
  # possible reasons for mysterious intermittent failures.
  #
  # We may try disabling this later, to see whether we still need it.
  def wait_for_jquery
    Timeout.timeout(Capybara.default_wait_time) do
      until page.evaluate_script("$.active === 0")
      end
    end
  end

  def sign_up
    first(:link, "Sign Up").click
    find("input[placeholder='Email']").set("user@example.com")
    find("input[placeholder='Password']").set("password")
    find("input[placeholder='Password confirmation']").set("password")
    click_button "Sign Up"    
    page.should have_text("Your account has been created")
  end

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
