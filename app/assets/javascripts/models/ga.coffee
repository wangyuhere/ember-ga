clientId = GaConfig.clientId
apiKey = GaConfig.apiKey
scopes = 'https://www.googleapis.com/auth/analytics.readonly'
authorized = false
loaded = false

EmberGa.GA =
  isAuthorized: ->
    authorized

  isLoaded: ->
    loaded

  load: ->
    new Ember.RSVP.Promise((resolve, reject) ->
      if loaded
        resolve()
      else
        window.handleClientLoad = ->
          gapi.client.setApiKey apiKey
          loaded = true
          resolve()
        $.getScript('https://apis.google.com/js/client.js?onload=handleClientLoad')
    )

  auth: ->
    new Ember.RSVP.Promise((resolve, reject) ->
      gapi.auth.authorize {client_id: clientId, scope: scopes, immediate: true}, (authResult) ->
        if authResult
          gapi.client.load 'analytics', 'v3', ->
            authorized = true
            resolve gapi.client.analytics
        else
          reject 'unauthorized'
      )

  listAccounts: ->
    new Ember.RSVP.Promise((resolve, reject) ->
      gapi.client.analytics.management.accounts.list().execute((results) ->
        resolve $.map(results.items, (item) ->
          EmberGa.Account.create(item)
        )
      )
    )

  listWebProperties: (accountId) ->
    new Ember.RSVP.Promise((resolve, reject) ->
      gapi.client.analytics.management.webproperties
        .list({'accountId': accountId}).execute((results) ->
          resolve results.items
        )
    )

  listProfiles: (accountId, propertyId) ->
    new Ember.RSVP.Promise((resolve, reject) ->
      gapi.client.analytics.management.profiles
        .list({'accountId': accountId, 'webPropertyId': propertyId})
        .execute((results) ->
          resolve results.items
        )
    )

  fetch: (param) ->
    new Ember.RSVP.Promise((resolve, reject) ->
      gapi.client.analytics.data.ga.get(param).execute((results) ->
        console.log results
        resolve results
      )
    )
