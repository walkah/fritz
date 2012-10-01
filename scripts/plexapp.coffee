# Description:
#   Script to interact with plex media server
#
# Commands:
#   hubot shows - show TV shows that are "on deck"
#   hubot movies - list available, unwatched movies

parser = require("xml2js").Parser

module.exports = (robot) ->
  robot.respond /shows/i, (msg) ->
    PlexAPI msg, 'library/sections/2/onDeck', (data) ->
      for video in data['Video']
        msg.send video['@']['grandparentTitle'] + ": Episode " + video['@']['index']

  robot.respond /movies/i, (msg) ->
    PlexAPI msg, 'library/sections/1/unwatched', (data) ->
      for video in data['Video']
        msg.send video['@']['title']

PlexAPI = (msg, query, cb) ->
  plex_host = process.env.HUBOT_PLEX_HOST
  plex_port = process.env.HUBOT_PLEX_PORT

  msg.http("http://#{plex_host}:#{plex_port}/#{query}")
    .get() (err, res, body) ->
      (new parser).parseString body, (err, data)->
        cb data
