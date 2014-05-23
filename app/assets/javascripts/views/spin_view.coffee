EmberGa.SpinView = Ember.View.extend
  tagName: 'div'

  didInsertElement: ->
    new Spinner().spin @.$()[0]
