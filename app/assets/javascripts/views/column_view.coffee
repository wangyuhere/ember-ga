EmberGa.ColumnView = Ember.View.extend
  column: null
  tagName: 'a'
  attributeBindings: ['href']
  href: '#'

  click: (e) ->
    @get('controller').send 'columnClicked', @get('column'), e

  mouseEnter: (e) ->
    @get('controller').send 'columnEntered', @get('column'), e
