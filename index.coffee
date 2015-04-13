express       = require 'express'
socketIo      = require 'socket.io'
rabbit        = require 'rabbit.js'
errorHandler  = require 'errorhandler'
connectAssets = require 'connect-assets'
layout        = require 'express-layout'
logger        = require 'morgan'
amqp          = require 'amqplib'

app = express()

server = app.listen(33410)

app.use(logger('combined'))
app.use(errorHandler(dumpExceptions: true, showStack: true))
app.use(connectAssets(
  servePath: '/assets'
  paths: [
    'app/assets/stylesheets'
    'app/assets/javascripts'
    'app/assets/images'
    'bower_components'
  ]
))

app.set('views', './app/views')
app.set('view engine', 'jade')

app.use(layout())
app.set('layouts', './app/views/layouts')
app.set('layout', 'application')

io = socketIo.listen(server)

# rmq = rabbit.createContext('amqp://localhost')
amqp.connect 'amqp://localhost'
  .then (rabbit) ->
    rabbit.createChannel()
  .then (channel) ->
    channel.assertQueue('testing').then (queue) ->
      io.on 'connection', (socket) ->
        socket.join('main')

        socket.on 'message', (data) ->
          channel.publish('', 'testing', new Buffer(JSON.stringify(data: data)))

        channel.consume 'testing', (msg) ->
          payload = JSON.parse(msg.content)
          socket.emit 'messageSend', {type: 'message', payload: payload}

app.get '/', (req, res) ->
  res.render 'index'
