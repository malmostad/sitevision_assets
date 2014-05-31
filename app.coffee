express = require 'express'
app = express()
app.use express.static(__dirname + '/public')
port = process.argv[2] or 3000

app.get '/', (request, response) ->
  response.send "Simple ExpressJS assets server for local development"

server = app.listen parseInt(port), ->
  console.log "Listening on port #{server.address().port}"
  console.log "Press CTRL-C to stop server."
