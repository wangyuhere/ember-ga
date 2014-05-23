EmberGa.Router.reopen
  location: 'history'

EmberGa.Router.map ->
  @route 'auth'
  @route 'columns', queryParams: ['category']
