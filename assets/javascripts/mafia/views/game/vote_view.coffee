class Mafia.Game.VoteView extends Mafia.View
  id: 'mafia-game-vote-view'
  class: 'vote-view'
  template: _.template '''
    <ul class="current-user-wrap"></ul>
    <ul class="peer-users-wrap"></ul>
  '''

  initialize: ->
    @_addFakeUsers()
    @_render()
    @_renderCurrentUser()
    # @_renderPeerUsers()
    @_position()

  _render: ->
    @$el.html @template()
    @$currentUserWrap = @$(".current-user-wrap")
    @$peerUsersWrap = @$(".peer-users-wrap")

  _position: ->
    @parent.$section_wrap.append @$el

  _addFakeUsers: ->
    @collection.add @model
    @collection.addFakeUsers()

  _renderCurrentUser: ->
    new Mafia.Game.Vote.CurrentUserView app: @app, parent: this, $wrap: @$currentUserWrap, model: @model

  _renderPeerUsers: ->
    @collection.each (peerUser) =>
      unless peerUser.cid is @model.cid
        new Mafia.Game.Vote.PeerUserView app: @app, parent: this, $wrap: @$peerUsersWrap, model: peerUser