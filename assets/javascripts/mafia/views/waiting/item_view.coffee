class Mafia.Waiting.ItemView extends Mafia.View
  className: "waiting-list-view"
  tagName: "li"
  template: _.template '''
    <div class='user-info'><%- userName %></div>
  '''

  initialize: (options) ->
    {@$wrap} = options
    @_render()
    @_position()

  _render: ->
    @$el.html @template @model.attributes

  _position: ->
    @$wrap.append @$el
