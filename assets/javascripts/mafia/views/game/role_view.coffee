class Mafia.Game.RoleView extends Mafia.View
  id: 'mafia-game-role-view'

  template: _.template '''
    <div class="user-id-card <%- user.role %>">
      <div class="issuer-name truncate">Global Game Jam 2017</div>
      <div class="avatar">
        <div class="mafia-avatar type-<%- user.avatarId %> bg-<%- user.avatarBg %>"></div>
      </div>
      <div class="user-name"><%- user.userName %></div>
      <div class="user-role"><%- _(user.role).titleize() %></div>
      <div class="user-description">
        <div class="visible-role-villager">Wins if there are no mafia remaining.</div>
        <div class="visible-role-police">Suspects one person every night. Receives a report on that person. Sided with the village.</div>
        <div class="visible-role-mafia">Chooses one person to kill every night. Wins when the mafia outnumber the village.</div>
        <div class="visible-role-doctor">Can choose one person to save every night. Sided with the village.</div>
      </div>
    </div>
    <% if(user.role != "villager" && scene % 2 == 0)  { %>
    <div class="special-vote-area">
      <div class="area-title"><%- _(user.role).titleize() %> meeting</div>
        <ul class="current-user-wrap"></ul>
        <ul class="peer-users-wrap"></ul>
      </div>
    </div>
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
