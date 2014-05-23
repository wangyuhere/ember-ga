EmberGa.ColumnsRoute = Ember.Route.extend
  setupController: (controller) ->
    controller.set 'columns', EmberGa.Columns
