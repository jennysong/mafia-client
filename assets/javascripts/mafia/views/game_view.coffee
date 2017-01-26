class Mafia.GameView extends Mafia.View
  id: 'mafia-game-view'
  template: _.template '''
    <div class="game-view-header">
      <div class="visible-playing">
        <div class="header-title-wrap"></div>
      </div>
      <div class="section-btns">
        <div class="visible-playing">
          <a class="change-section section-btn" data-section="vote">Vote</a>
          <a class="change-section section-btn" data-section="chat">Chat</a>
          <a class="change-section section-btn" data-section="role">Role</a>
        </div>
        <div class="visible-finished">
          <a class="section-btn leave-room">Leave Room</a>
        </div>
      </div>
    </div>
    <div class="game-view-notification"></div>
    <div class="game-view-body"></div>
  '''

  header_title_template: _.template '''
    <div class="current-scene-item">
      <div class="bullet">
        <span class="entypo light-up visible-status-day"></span>
        <span class="entypo moon visible-status-night"></span>
      </div>
      <div class="item-name"><%- scene_name %> <span class="count"><%- scene_count %></span></div>
    </div>
  '''
  MAFIA_WIN_SCENE_NUMBER:    666
  VILLAGER_WIN_SCENE_NUMBER: 999
  finished: false

  sections:
    chat: 'ChatView'
    vote: 'VoteView'
    role: 'RoleView'

  initialize: (options = {scene: 1}) ->
    @users    = @collection
    @messages = new Mafia.Collections.Messages
    @_get_role_counts_add_as_system_messages()

    @_render()
    @_position()
    @_refresh_frame scene: @app.scene
    @_refresh_section 'chat'

    @_initialize_sockets()
    @_initialize_application_trigers()

    @_add_listenTo_to_models()
    switch @app.scene
      when @MAFIA_WIN_SCENE_NUMBER, @VILLAGER_WIN_SCENE_NUMBER
        @finished = true

    @_refresh_status_class()

  events:
    'click .change-section': 'change_section'
    'click .leave-room': 'leave_room'

  change_section: (e)->
    $btn = $(e.currentTarget)
    @_refresh_section $btn.data 'section'

  leave_room: (e) ->
    @app.socket.emit('leave current room')

  _render: ->
    @$el.html @template()
    @$section_wrap = @$(".game-view-body")
    @$header_title_wrap = @$(".header-title-wrap")
    @$notifiation_wrap = @$(".notification-wrap")
    @$notification_wrap = @$(".game-view-notification")

  _refresh_section: (section)->
    @current_section_tab.removeClass 'selected' if @current_section_tab
    @current_section_view.remove() if @current_section_view
    @current_section = section
    view_name = @sections[@current_section]
    @current_section_view = new Mafia.Game[view_name] app: @app, parent: this, model: @model, collection: @users
    @current_section_tab = @$(".section-tab.#{section}").addClass 'selected'


  _refresh_frame: (options) ->
    {scene} = options
    time_of_the_day = if _(scene).isOdd() then 'Day' else 'Night'
    @$header_title_wrap.html @header_title_template
      scene_name: time_of_the_day
      scene_count: Math.ceil(scene/2)

    @$el.removeClass('status-day status-night').addClass "status-" + time_of_the_day.toLowerCase()

  _initialize_sockets: ->
    @app.socket.on 'general vote update', (current_users) =>
      @users.updatesCollectionByIndex current_users
      @users.each (user) -> user.trigger 'vote-updated'
      @_hide_notification()

    @app.socket.on 'special vote update', (current_users) =>
      @users.updatesCollectionByIndex current_users
      @users.each (user) -> user.trigger 'vote-updated'

    @app.socket.on 'vote result', (game_data) =>
      @_hide_notification()
      @users.updatesCollectionByIndex game_data.users
      @messages.add_system_message game_data.policeMessage if game_data.policeMessage and (@model.get("role") is "police")
      @app.trigger 'vote-result-received', game_data

      @app.scene = game_data.scene
      # @users.check_and_reset_votes() if _(@scene).isOdd()
      deadUser = if game_data.deadUserId then @users.get(game_data.deadUserId) else null
      @trigger 'show-vote-result', deadUser

    @app.socket.on "update message", (message_attrs) =>
      message_attrs.type = 'user'
      message = new @messages.model message_attrs
      message.user = @users.get message_attrs.userId
      @messages.add message

    @app.socket.on 'start general vote countdown', =>
      countdown_view = new Mafia.Game.CountdownView
        message: 'Countdown #number!', time: 5
      @_show_notification countdown_view

    @app.socket.on 'start special vote countdown', =>
      countdown_view = new Mafia.Game.CountdownView
        message: 'Countdown #number!', time: 5
      @_show_notification countdown_view

  _initialize_application_trigers: ->
    @on 'show-vote-result', (deadUser)=>

      new Mafia.Dialogs.GameResultDialogView
        app: @app, parent: this, model: deadUser
        after_show: =>
          if (@app.scene is @MAFIA_WIN_SCENE_NUMBER) or (@app.scene is @VILLAGER_WIN_SCENE_NUMBER)
            @messages.add_system_message @model.get_result(@app.scene)
            @finished = true
            @app.scene = "1554"
            @_refresh_status_class()
            @users.reviveAll()
            @_refresh_section 'chat'
          else
            @_refresh_frame scene: @app.scene
            @messages.add_system_message "You are required to vote. Go role tab and vote" if @model.get("alive") and (@model.get("role") isnt "villager") and @app.scene % 2 == 0
            if _(@app.scene).isOdd() or (@model.get("role") is "villager")
              @_refresh_section 'chat'
            else
              @_refresh_section 'role'


  _refresh_status_class: ->
    if @finished
      @$el.removeClass('playing').addClass 'finished'
    else
      @$el.removeClass('finished').addClass 'playing'


  remove: ->
    @app.socket.off 'general vote update'
    @app.socket.off 'special vote update'
    @app.socket.off 'vote result'
    @app.socket.off 'update message'
    super

  _hide_notification: ->
    @$el.removeClass 'notification-show'

  _show_notification: (view) ->
    @$notification_wrap.html view.el if view instanceof Backbone.View
    @$el.addClass 'notification-show'

  _get_role_counts_add_as_system_messages: ->
    _(@users.get_role_counts()).each (value, key) =>
      @messages.add_system_message "#{key}: #{value}" if value

  _add_listenTo_to_models: ->
    @users.each (user) =>
      @listenTo user, 'change:generalVote', @_voted

  _voted: (user) ->
    if _(@app.scene).isOdd()
      if voted_user_id = user.get("generalVote")
        if voted_user_id
          voted_user = @users.get(voted_user_id)
          @messages.add_system_message "#{user.get("userName")} voted #{voted_user.get("userName")}"

