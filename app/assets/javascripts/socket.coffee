# = require socket.io-client/socket.io

mod = angular.module('wtandy.socket', [])


mod.provider 'Websocket', [->
  socketUrl = 'http://localhost:33410/'

  setWebsocketUrl: (url) ->
    socketUrl = url

  $get: ->
    class Websocket
      constructor: (opts = {}) ->
        @messageCallbacks = {}

        console.log socketUrl
        @socket = io.connect(socketUrl, {})

        @socket.on('connect', @onConnected)
        @socket.on('disconnect', @onDisconnected)
        @socket.on('messageSend', @handleMessage)

      onConnected: =>
      onDisconnected: =>

      handleMessage: (message) =>
        console.log 'message received:', message.type, message.payload
        # $rootScope.$apply =>
        if @messageCallbacks[message.type]
          for cb in @messageCallbacks[message.type]
            cb(message.payload)

      on: (type, callback) =>
        @messageCallbacks[type] ||= []
        @messageCallbacks[type].push(callback)

      emit: (type, data) =>
        console.log 'message sent:', type, data
        @socket.emit(type, data)

]
