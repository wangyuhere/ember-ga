ga = EmberGa.GA

EmberGa.IndexRoute = Ember.Route.extend
  beforeModel: (transition)->
    @transitionTo 'auth' unless ga.isAuthorized()
    @_super transition

  setupController: (controller) ->
    controller.set 'columns', EmberGa.Columns
    ga.listAccounts().then (accounts) ->
      controller.set 'accounts', accounts
      controller.set 'currentAccount', accounts[0] if accounts.length > 0
