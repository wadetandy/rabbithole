# = require angular/angular
# = require angular-resource/angular-resource
# = require angular-route/angular-route
# = require ./socket

app = angular.module('rabbitHoleConsole', ['ngResource', 'ngRoute', 'wtandy.socket'])

app.controller 'ConsoleCtrl', ['$scope', 'Websocket', ($scope, Websocket) ->
  socket = new Websocket()

  $scope.submit = ->
    socket.emit('message', $scope.message)
]

