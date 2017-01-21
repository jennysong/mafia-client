class Mafia.Game.VoteView extends Mafia.View
  id: 'mafia-game-vote-view'
  class: 'vote-view'
  template: _.template '''
    Vote View
  '''

  initialize: ->
    @_render()
    @_position()

  _render: ->
    @$el.html @template()

  _position: ->
    @parent.$section_wrap.append @$el