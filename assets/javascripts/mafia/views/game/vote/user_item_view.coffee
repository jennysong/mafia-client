class Mafia.Game.Vote.UserItemView extends Mafia.View
  id: 'mafia-game-vote-user-item-view'
  class: 'user-item-view'
  tagName: 'li'
  template: _.template '''
    <div class="user-item">
      <div class="user-info left">
        <span class='mafia-avatar size-small type-<%- user.avatarId %> round bg-<%- user.avatarBg %>'></span>
        <div class="userName"><%- user.userName || "Unknown" %></div>
      </div>
      <div class="user-info vote right">
        <% if(votedUser) { %>
          <span class='mafia-avatar size-small type-<%- votedUser.avatarId %> round bg-<%- votedUser.avatarBg %>'></span>
          <div class="userName"><%- votedUser.userName || "Unknown" %></div>
        <% } %>
        <div class="place-holder">
          <span class='mafia-avatar size-small type-0 round'></span>
            <div class="userName">Not Voted</div>
        </div>
      </div>
      <div class="arrow"><span class='entypo right inline'></span></div>

    </div>
  '''

  initialize: (options) ->
    {@$wrap, @votable, @type} = options
    @_render()
    @_position()

    @app.on 'vote-updated', =>
      @_refresh()
    @_togglePlaceHolder()

  events:
    'click .vote': 'vote'

  _render: ->
    data = {user: @model.toJSON(), votedUser: null}
    @voted_user_id = @model.get  "#{@type}Vote"
    if @voted_user_id
      @voted_user = @app.users.get @voted_user_id
      data["votedUser"] = @voted_user.toJSON() if @voted_user
    @$el.html @template data

  _togglePlaceHolder: ->
    if @voted_user_id && @voted_user
      @$el.removeClass 'show-place-holder'
    else
      @$el.addClass 'show-place-holder'

  _refresh: =>
    @_render()
    @_togglePlaceHolder()

  _position: ->
    @$wrap.append @$el

  vote: =>
    if @_check_votable()
      @vote_player_dialog = @new Mafia.Dialogs.VotePlayerDialogView,
        app: @app, parent: this, current_user: @app.current_user, users: @collection,
        after_select: (model) =>
          @app.current_user.set "#{@type}Vote", model.id
          @app.socket.emit("#{@type} vote", model.id)
          @_refresh()
          @vote_player_dialog.close()

  _check_votable: ->
    output = false
    if @votable and @model.get("alive")
      isOdd = _(@app.scene).isOdd()
      if (@type is "general") and isOdd
        output = true
      else if !isOdd
        output = true
      else
        output = false
    else
      output = false
    output



