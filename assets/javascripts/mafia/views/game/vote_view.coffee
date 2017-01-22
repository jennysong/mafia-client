class Mafia.Game.VoteView extends Mafia.View
  id: 'mafia-game-vote-view'
  class: 'vote-view'
  template: _.template '''
    <ul class="current-user-wrap"></ul>
    <ul class="peer-users-wrap"></ul>
  '''

  initialize: ->
    @_render()
    @_renderCurrentUser()
    @_renderPeerUsers()
    @_position()

  _render: ->
    @$el.html @template()
    @$currentUserWrap = @$(".current-user-wrap")
    @$peerUsersWrap = @$(".peer-users-wrap")

  _position: ->
    @parent.$section_wrap.append @$el

  # _addFakeUsers: ->
  #   @collection.add @model
  #   @collection.addFakeUsers()

  _renderCurrentUser: ->
    new Mafia.Game.Vote.UserItemView
      app: @app, parent: this, $wrap: @$currentUserWrap, model: @model,
      collection: @collection, votable: true, type: 'general'

  _renderPeerUsers: ->
    @collection.each (peerUser) =>
      unless peerUser.id is @model.id
        new Mafia.Game.Vote.UserItemView
          app: @app, parent: this, $wrap: @$peerUsersWrap, model: peerUser
