class Mafia.Helpers.Configuration
  prefix: 'mafia'
  set: (key, value) ->
    localStorage.setItem @_get_key(key), value

  get: (key) ->
    localStorage.getItem @_get_key(key)

  unset: (key) ->
    localStorage.removeItem @_get_key(key)

  _get_key: (key) ->
    [@prefix, key].join('/')