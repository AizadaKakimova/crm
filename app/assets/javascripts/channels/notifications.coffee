App.statuses = App.cable.subscriptions.create "NotificationsChannel",
  connected: ->

  disconnected: ->

  received: (data) ->
    console.log data