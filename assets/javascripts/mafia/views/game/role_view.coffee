class Mafia.Game.RoleView extends Mafia.View
  id: 'mafia-game-role-view'
  class: 'role-view'

  template: _.template '''
    <div class="title">You are a <%- user.role %>!</div>
    <% if(user.role != "villager" && scene % 2 == 0)  { %>
      <ul class="current-user-wrap"></ul>
      <ul class="peer-users-wrap"></ul>
    <% } %>
  '''

  initialize: ->
    @_render()
    unless @model.get("role") is "villager"
      @_renderCurrentUser()
      @_renderPeerUsers()

    @_position()



  _render: ->
    @$el.html @template {user: @model.toJSON(), scene: @app.scene}
    @$currentUserWrap = @$(".current-user-wrap")
    @$peerUsersWrap = @$(".peer-users-wrap")

  _position: ->
    @parent.$section_wrap.append @$el

  _renderCurrentUser: ->
    new Mafia.Game.Vote.UserItemView
      app: @app, parent: this, $wrap: @$currentUserWrap, model: @model,
      collection: @collection, votable: true, type: 'special'

  _renderPeerUsers: ->
    @collection.each (peerUser) =>
      if peerUser.id is @model.id
        #do nothing
      else if peerUser.get("role") == @model.get("role")
        new Mafia.Game.Vote.UserItemView
          app: @app, parent: this, $wrap: @$peerUsersWrap, model: peerUser, type: 'special'
