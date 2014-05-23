EmberGa.ColumnsController = Ember.Controller.extend
  columns: []

  actions:
    columnClicked: (e) ->
      console.log 'clicked'
    columnEntered: (e) ->
      console.log e

  metrics: (->
    @get('columns').filter (c) ->
      c.type is 'METRIC'
  ).property 'columns'

  dimensions: (->
    @get('columns').filter (c) ->
      c.type is 'DIMENSION'
  ).property 'columns'
