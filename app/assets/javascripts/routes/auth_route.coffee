EmberGa.AuthRoute = Ember.Route.extend
  beforeModel: (transition) ->
    ga = EmberGa.GA
    ga.load().then(ga.auth).then =>
      @transitionTo 'index'
