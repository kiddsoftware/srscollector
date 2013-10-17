# -*- coding: utf-8 -*-
require "spec_helper"

feature "Add definitions to a snippet", :js => true do
  let!(:dict1) do
    FactoryGirl.create(:dictionary, name: "Dict1", from_lang: "fr",
                       to_lang: "fr", url_pattern: "http://example.com/d1/%s",
                       score: 1.0)
  end

  let!(:dict2) do
    FactoryGirl.create(:dictionary, name: "Dict2", from_lang: "fr",
                       to_lang: "en", url_pattern: "http://example.com/d2/%s",
                       score: 0.5)
  end

  scenario "User pastes a phrase, selects a word, tries two dictionaries" do
    visit "/"
    fill_in_html "#front", with: "suis"
    select_all "#front"
    first(".rich-editor").click_link("Lookup")
    expect_nested_page('http://example.com/d1/suis')
    select('Dict2', from: "Dictionary")
    expect_nested_page('http://example.com/d2/suis')
    fill_in_html "#back", with: "am"
    click_button "Next"
    click_link "Export cards"
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
