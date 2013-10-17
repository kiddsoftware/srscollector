class StaticController < ApplicationController
  PAGES=%w(index)
  PAGES.each do |page|
    define_method(page) {}
  end
end
