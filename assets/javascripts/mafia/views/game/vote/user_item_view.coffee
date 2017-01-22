class Mafia.Game.Vote.UserItemView extends Mafia.View
  id: 'mafia-game-vote-user-item-view'
  class: 'user-item-view'
  tagName: 'li'
  template: _.template '''
    <div class="user-item">
      <div class="user-info left">
        <span class='mafia-avatar size-small type-<%- currentUser.avatarId %> round size-large bg-<%- currentUser.avatarBg %>'></span>
        <div class="userName"><%- currentUser.userName %></div>
      </div>
      <div class="user-info vote right">
        <% if(votedUser) { %>
          <span class='mafia-avatar size-small type-<%- votedUser.avatarId %> round size-large bg-<%- votedUser.avatarBg %>'></span>
          <div class="userName"><%- votedUser.userName %></div>
        <% } %>
        <div class="place-holder">
          <span class='mafia-avatar size-small type-1 round size-large bg-red'></span>
        </div>
      </div>
      <div class="arrow"><span class='entypo right inline'></span></div>

    </div>
  '''

  initialize: (options) ->
    {@$wrap, @votable, @type} = options
    @_render()
    @_position()

    @listenTo @model, 'change', @_refresh
    @_togglePlaceHolder()
  events:
    'click .vote': 'vote'

  _render: ->
    data = {currentUser: @model.toJSON(), votedUser: null}
    @voted_user_id = @app.current_user.get  "#{@type}Vote"
    if @voted_user_id
      @voted_user = @app.users.get @voted_user_id
      data["votedUser"] = @voted_user
    @$el.html @template data

  _togglePlaceHolder: ->
    if @voted_user_id && @voted_user
      @$el.removeClass 'show-place-holder'
    else
      @$el.addClass 'show-place-holder'

  _refresh: ->
    @_render()

  _position: ->
    @$wrap.append @$el

  vote: =>
    if @votable and @model.get("alive")
      @vote_player_dialog = @new Mafia.Dialogs.VotePlayerDialogView,
        app: @app, parent: this, current_user: @app.current_user, users: @collection,
        after_select: (model) =>
          @app.current_user.set "#{@type}Vote", model.id
          console.log @app.current_user
          @app.socket.emit("#{@type} vote", model.id)
          @vote_player_dialog.close()
