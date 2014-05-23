EmberGa.ColumnsFilterComponent = Ember.Component.extend
  columns: []
  inputString: ''
  curColumn: null

  actions:
    columnClicked: (column, e) ->
      str = @get 'inputString'
      @set 'inputString', str.substring(0, str.length - @get('query').length) + column.id + ','
    columnEntered: (column, e) ->
      @set 'curColumn', column

  query: (->
    str = @get 'inputString'
    matches = str.match(/,([^,]*)$/)
    if matches
      matches[1]
    else
      str
  ).property 'inputString'

  results: (->
    query = @get('query').toLowerCase()
    columns = @get 'columns'
    return columns if query is ''
    columns.filter (c) ->
      c.id.toLowerCase().indexOf(query) != -1
  ).property 'query'

  setup: (->
    input = @.$('input.form-control')
    list = @.$('.columns-list')
    listGroup = @.$('.list-group')
    list.hide()

    $(document).mouseup (e) =>
      panel = @.$('.panel')
      hided = true
      $.each [input, listGroup, panel], (i, elm) ->
        hided = false if elm.is(e.target) or elm.has(e.target).length != 0
      list.hide() if hided

    input.focus ->
      list.show()

  ).on 'willInsertElement'
