class Mafia.GameView extends Mafia.View
  id: 'mafia-game-view'
  template: _.template '''
    <div class="game-view-header">
      <div class="header-title-wrap"></div>
      <div class="section-btns">
        <a class="change-section section-btn" data-section="vote">Vote</a>
        <a class="change-section section-btn" data-section="chat">Chat</a>
        <a class="change-section section-btn" data-section="role">Role</a>
      </div>
    </div>
    <div class="notification-wrap"></div>
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

  sections:
    chat: 'ChatView'
    vote: 'VoteView'
    role: 'RoleView'

  initialize: (options = {scene: 1}) ->

    @users = @collection
    @_render()
    @_position()
    @_refresh_frame scene: 1
    @_refresh_section 'chat'


    @app.socket.on 'general vote update', (current_users) =>
      @users.updatesCollectionByIndex current_users
      @app.trigger 'general vote updated'

  events:
    'click .change-section': 'change_section'

  _render: ->
    @$el.html @template()
    @$section_wrap = @$(".game-view-body")
    @$header_title_wrap = @$(".header-title-wrap")
    @$notifiation_wrap = @$(".notification-wrap")

  change_section: (e)->
    $btn = $(e.currentTarget)
    @_refresh_section $btn.data 'section'

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


