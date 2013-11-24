# This is a manifest file that'll be compiled into application.js, which will include all the files
# listed below.
#
# Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
# or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
#
# It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# compiled file.
#
# Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
# about supported directives.
#
#= require_tree ./vendor
#= require jquery
#= require jquery.form
#= require jquery_ujs
#= require handlebars
#= require ember
#= require ember-data
#= require bootstrap
#= require wysihtml5/dist/wysihtml5-0.3.0.js

#= require ./srs_collector
#= require ./store
#= require_tree ./lib
#= require_tree ./models
#= require_tree ./controllers
#= require_tree ./views
#= require_tree ./templates
#= require_tree ./routes
#= require ./router

#= require_self
