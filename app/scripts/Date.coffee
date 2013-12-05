if typeof Date::getHours12 is "undefined"
  Date::getHours12 = ->
    hours = @getHours()
    (if hours > 12 then hours - 12 else hours)
