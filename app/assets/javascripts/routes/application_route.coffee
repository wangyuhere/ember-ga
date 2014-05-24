EmberGa.ApplicationRoute = Ember.Route.extend
  actions:
    queryParamsDidChange: ->
      @refresh()
