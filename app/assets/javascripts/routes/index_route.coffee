ga = EmberGa.GA

EmberGa.IndexRoute = Ember.Route.extend
  beforeModel: (transition, params)->
    @transitionTo 'auth' unless ga.isAuthorized()
    @_super transition, params

  setupController: (controller) ->
    controller.set 'allColumns', EmberGa.Columns
    ga.listAccounts().then (accounts) ->
      controller.set 'accounts', accounts
      controller.set 'currentAccount', accounts[0] if accounts.length > 0
