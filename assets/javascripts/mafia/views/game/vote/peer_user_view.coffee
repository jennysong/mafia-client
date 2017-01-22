class Mafia.Game.Vote.PeerUserView extends Mafia.View
  id: 'mafia-game-vote-peer-user-view'
  class: 'peer-user'
  tagName: 'li'
  template: _.template '''
    <div class="user-item">
      <div class="user-info left">
        <span class='mafia-avatar size-small type-<%- peerUser.avatarId %> round size-large bg-<%- peerUser.avatarBg %>'></span>
        <div class="userName"><%- peerUser.userName %></div>
      </div>
      <div class="user-info right">
        <div class="place-holder">
          <span class='mafia-avatar size-small type-1 round size-large bg-red'></span>
        </div>
      </div>
      <div class="arrow"><span class='entypo right inline'></span></div>
    </div>
  '''

  initialize: (options) ->
    {@$wrap} = options
    @_render()
    @_position()

  events:
    'click .vote': 'vote'

  _render: ->
    @$el.html @template {peerUser: @model.toJSON()}

  _position: ->
    @$wrap.append @$el

  vote: ->
    console.log "Need to Vote"