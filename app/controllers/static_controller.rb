class StaticController < ApplicationController
  PAGES=%w(index placeholder)
  PAGES.each do |page|
    define_method(page) {}
  end

  layout "blank", :only => :placeholder
end
