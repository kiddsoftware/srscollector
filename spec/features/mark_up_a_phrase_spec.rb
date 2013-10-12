# -*- coding: utf-8 -*-
require "spec_helper"

feature "Add definitions to a snippet", :js => true do
  scenario "User pastes a phrase and selects a word" do
    visit "/"
    fill_in_html "#front", with: "suis"
    select_all "#front"
    click_button("Lookup")
    iframe_location.should == "http://fr.wiktionary.org/wiki/suis"
  end

  def fill_in_html(field, options)
    with = options[:with]
    page.execute_script(<<"EOD")
(function () {
  var wysihtml5 = $(#{field.to_json}).data("wysihtml5");
  var editor = wysihtml5.editor;
  editor.setValue(#{with.to_json});
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

  def iframe_location
    page.evaluate_script("$('#dictionary').attr('src')")
  end
end
