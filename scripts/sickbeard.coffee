# Interact with a SickBeard server
#
# tv (today|soon|later) - Return upcoming shows

module.exports = (robot) ->
  robot.respond /tv (soon|today|later)/i, (msg) ->
    type = msg.match[1]
    SickBeard msg, {cmd: "future", sort: "date", type: type}, (response) ->
      output = ""
      for show in response.data[type]
        output += "#{show.show_name}: #{show.ep_name} (#{show.airdate})\n"
      msg.send output

SickBeard = (msg, query, cb) ->
  sb_host = process.env.HUBOT_SICKBEARD_HOST
  sb_port = process.env.HUBOT_SICKBEARD_PORT
  sb_key  = process.env.HUBOT_SICKBEARD_KEY
  msg.http("http://#{sb_host}:#{sb_port}/api/#{sb_key}/")
    .query(query)
    .get() (err, res, body) ->
      cb JSON.parse(body)
