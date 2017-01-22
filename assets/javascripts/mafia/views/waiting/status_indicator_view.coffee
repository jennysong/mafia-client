class Mafia.Waiting.StatusIndicatorView extends Mafia.View
  className: 'status-indicator'
  templates:
    waiting: _.template '''
      Waiting Players...
    '''

    counting: _.template '''
      <%- count %>
    '''

  initialize: (options) ->
    {@$wrap} = options

    @_render_waiting()
    @_position()

  start_counting: ->
    clearInterval @_counter
    @counting = true
    @_count = 10
    @$el.addClass('counting').removeClass('waiting')

    @_counter = setInterval =>
      @_count = @_count - 1
      @_render_counting @_count
      clearInterval @_counter if @_count <= 0
    , 1000

  stop_counting: ->
    clearInterval @_counter
    @counting = false
    @_render_waiting()
    @$el.addClass('waiting').removeClass('counting')

  _render_waiting: ->
    @$el.html @templates.waiting()

  _render_counting: (count) ->
    @$el.html @templates.counting count: count

  _position: ->
    @$wrap.append @el

  remove: ->
    clearInterval @_counter
    super