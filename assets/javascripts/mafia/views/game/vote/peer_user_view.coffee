class Mafia.Game.Vote.PeerUserView extends Mafia.View
  id: 'mafia-game-vote-peer-user-view'
  class: 'peer-user'
  tagName: 'li'
  template: _.template '''
    <div class="user">
      <div class="avatar-wrap">
        <span class='mafia-avatar size-small type-<%- avatarId %> round size-large bg-<%- avatarBg %>'></span>
      </div>
      <span class='entypo right'></span>
      <div class="vote">
        <div class="place-holder">
          <span class='mafia-avatar size-small type-2 round size-large bg-blue'></span>
        </div>
      </div>
    </div>
  '''

  initialize: (options) ->
    {@$wrap} = options
    @_render()
    @_position()

  events:
    'click .vote': 'vote'

  _render: ->
    @$el.html @template @model.toJSON()

  _position: ->
    @$wrap.append @$el

  vote: ->
    console.log "Need to Vote"