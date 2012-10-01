# Description:
#   Integration with SABnzbd
#
# Commands:
#   hubot downloads - show the download queue
#   hubot download pause - pause the download queue
#   hubot download resume - resume downloading

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
  sab_url = process.env.HUBOT_SABNZBD_URL
  sab_key  = process.env.HUBOT_SABNZBD_KEY
  msg.http("#{sab_url}/api?apikey=#{sab_key}")
    .query(query)
    .get() (err, res, body) ->
      cb JSON.parse(body)