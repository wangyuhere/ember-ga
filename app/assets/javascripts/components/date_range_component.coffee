EmberGa.DateRangeComponent = Ember.Component.extend
  inputId: 'date-range'
  startDate: moment().subtract("day", 29)
  endDate: moment()
  format: 'YYYY-MM-DD'
  separator: ' ~ '

  dateRange: (->
    format = @get 'format'
    @get('startDate').format(format) + @get('separator') + @get('endDate').format(format)
  ).property 'startDate', 'endDate'

  setDateRange: (->
    @sendAction 'action', @get('dateRange')
  ).observes('dateRange')

  setup: (->
    @.$('input.form-control').daterangepicker({
      format: @get('format')
      separator: @get('separator')
      startDate: @get('startDate')
      endDate: @get('endDate')
    },
    (start, end) =>
      @set 'startDate', start
      @set 'endDate', end
    )
    @sendAction 'action', @get('dateRange')
  ).on 'willInsertElement'
