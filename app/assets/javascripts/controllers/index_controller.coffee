EmberGa.IndexController = Ember.Controller.extend
  queryParams: [
    'startDate'
    'endDate'
    'filters'
    'segment'
    'sort'
    'samplingLevel'
    'startIndex'
    'maxResults'
  ]

  loading: false
  format: 'YYYY-MM-DD'

  accounts: []
  webProperties: []
  profiles: []
  allColumns: []

  ids: ''
  startDate: ''
  endDate: ''
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

  startDateObj: (->
    startDate = @get 'startDate'
    if startDate
      moment startDate, @get('format')
    else
      moment().subtract('day', 29)
  ).property 'startDate'

  endDateObj: (->
    endDate = @get 'endDate'
    if endDate
      moment endDate, @get('format')
    else
      moment()
  ).property 'endDate'

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
    @set 'ids', 'ga:' + @get('currentProfile').id
  ).observes('currentProfile')

  allMetrics: (->
    @get('allColumns').filter (c) ->
      c.type == 'METRIC'
  ).property 'query'

  allDimensions: (->
    @get('allColumns').filter (c) ->
      c.type == 'DIMENSION'
  ).property 'query'

  buildGaParam: (val) ->
    val.split(',').filter((v) -> v.trim() != '').join(',')

  buildParams: ->
    params =
      'ids': @get('ids')
      'start-date': @get('startDate')
      'end-date': @get('endDate')
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
    dateRangeChanged: (start, end) ->
      format = @get 'format'
      @set 'startDate', start.format(format)
      @set 'endDate', end.format(format)

    fetchData: ->
      params = @buildParams()
      @set 'loading', true
      EmberGa.GA.fetch(params).then (response) =>
        @set 'response', response
        @set 'loading', false
        $('.results').show()
