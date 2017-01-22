class Mafia.Game.CountdownView extends Mafia.View
  className: 'countdown-view'
  initialize: (options) ->
    {@message, @time, @after_stop} = options
    @current_time = @time

    @_refresh()
    @start()


  _refresh: ->
    @$el.html @message.replace(/#number/g, @current_time)
    @current_time = @current_time-1

  start: ->
    @_interval = setInterval =>
      @_refresh()
      @stop() if @current_time < 0
    , 1000

  stop: ->
    clearInterval @_interval
    @remove()
    @after_stop() if _(@after_stop).isFunction()