# Integration with SABnzbd
#
# downloads - show the download queue
# download pause - pause the download queue
# download resume - resume downloading

module.exports = (robot) ->
  robot.respond /downloads/i, (msg) ->
    SABnzbd msg, {mode: "qstatus", output: "json"}, (response) ->
      msg.send "#{response['jobs'].length} files - #{response['timeleft']} remaining"
      for job in response['jobs']
        msg.send "#{job['filename']}"

  robot.respond /download pause/i, (msg) ->
    SABnzbd msg, {mode: "pause", output: "json"}, (response) ->
      msg.send "OK, I'll stop"

  robot.respond /download resume/i, (msg) ->
    SABnzbd msg, {mode: "resume", output: "json"}, (response) ->
      msg.send "Here we go!"

SABnzbd = (msg, query, cb) ->
  sab_host = process.env.HUBOT_SABNZBD_HOST
  sab_port = process.env.HUBOT_SABNZBD_PORT
  sab_key  = process.env.HUBOT_SABNZBD_KEY
  msg.http("http://#{sab_host}:#{sab_port}/api?apikey=#{sab_key}")
    .query(query)
    .get() (err, res, body) ->
      cb JSON.parse(body)