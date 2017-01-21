class Mafia.Game.RoleView extends Mafia.View
  id: 'mafia-game-role-view'
  class: 'role-view'
  template: _.template '''
    Role View
  '''

  initialize: ->
    @_render()
    @_position()

  _render: ->
    @$el.html @template()

  _position: ->
    @parent.$section_wrap.append @$el