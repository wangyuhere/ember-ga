EmberGa.IndexController = Ember.Controller.extend
  loading: false
  accounts: []
  webProperties: []
  profiles: []
  columns: []
  dateRange: null
  dimensions: ''
  metrics: ''
  filters: ''
  segment: ''
  sort: ''
  startIndex: 1
  maxResults: 100
  samplingLevel: 'DEFAULT'
  samplingLevels: ['DEFAULT', 'FASTER', 'HIGHER_PRECISION']

  currentAccount: null
  currentWebProperty: null
  currentProfile: null

  accountChanged: (->
    EmberGa.GA.listWebProperties(@get('currentAccount').id).then (webProperties) =>
      @set('webProperties', webProperties)
      @set('currentWebProperty', webProperties[0]) if webProperties and webProperties.length > 0
  ).observes('currentAccount')

  webPropertyChanged: (->
    EmberGa.GA.listProfiles(@get('currentAccount').id, @get('currentWebProperty').id).then (profiles) =>
      @set('profiles', profiles)
      @set('currentProfile', profiles[0]) if profiles and profiles.length > 0
  ).observes('currentWebProperty')

  profileChanged: (->
  ).observes('currentProfile')

  metrics: (->
    @get('columns').filter (c) ->
      c.type == 'METRIC'
  ).property 'query'

  dimensions: (->
    @get('columns').filter (c) ->
      c.type == 'DIMENSION'
  ).property 'query'

  buildGaParam: (val) ->
    val.split(',').filter((v) -> v.trim() != '').map((v) -> 'ga:' + v).join(',')

  buildParams: ->
    dates = @get('dateRange').split(' ~ ')
    ids = 'ga:' + @get('currentProfile').id
    params =
      'ids': 'ga:' + @get('currentProfile').id
      'start-date': dates[0]
      'end-date': dates[1]
      'metrics': @buildGaParam($('#metrics input').val())
      'start-index': @get('startIndex')
      'max-results': @get('maxResults')
      'samplingLevel': @get('samplingLevel')

    dimensions = @buildGaParam($('#dimensions input').val())
    params['dimensions'] = dimensions if dimensions != ''

    filters = @get('filters').trim()
    params['filters'] = filters if filters != ''

    segment = @get('segment').trim()
    params['segment'] = segment if segment != ''

    sort = @get('sort').trim()
    params['sort'] = sort if sort != ''
    params

  actions:
    dateRangeChanged: (dateRange) ->
      @set 'dateRange', dateRange

    fetchData: ->
      @set 'loading', true
      promise = EmberGa.GA.fetch(
        @buildParams()
      ).then (response) =>
        @set 'response', response
        @set 'loading', false
        $('.results').show()
