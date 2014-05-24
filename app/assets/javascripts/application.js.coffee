#= require bootstrap
#= require daterangepicker
#= require spin.min
#= require_self
#= require ember_ga

window.EmberGa = Ember.Application.create()

Ember.TextField.reopen
  attributeBindings: ['data-toggle']
