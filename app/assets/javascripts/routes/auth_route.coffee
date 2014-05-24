EmberGa.AuthRoute = Ember.Route.extend
  beforeModel: (transition, params) ->
    ga = EmberGa.GA
    ga.load().then(ga.auth).then =>
      @transitionTo 'index'
