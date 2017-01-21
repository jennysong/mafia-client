class Mafia.Application.HeaderView extends Mafia.View
  id: 'application-header-view'
  tagName: 'header'
  className: 'header-view'

  template: _.template '''
    <div class="header-info actions">
      Mafia - info
    </div>
  '''

  initialize: ->
    @_render()
    @_position()

  _render: ->
    @$el.html @template

  _position: ->
    @parent.$body.before @el