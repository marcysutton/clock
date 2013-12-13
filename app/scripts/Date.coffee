if typeof Date::getFormattedSeconds is "undefined"
  Date::getFormattedSeconds = ->
    seconds = @getSeconds()
    (if seconds < 10 then '0' + seconds else seconds)

if typeof Date::getFormattedMinutes is "undefined"
  Date::getFormattedMinutes = ->
    minutes = @getMinutes()
    (if minutes < 10 then '0' + minutes else minutes)

if typeof Date::getFormattedHours is "undefined"
  Date::getFormattedHours = ->
    hours = @getHours12()
    (if hours < 10 then ((if hours is 0 then 12 else "0" + hours)) else hours)

if typeof Date::getHours12 is "undefined"
  Date::getHours12 = ->
    hours = @getHours()
    (if hours > 12 then hours - 12 else hours)
