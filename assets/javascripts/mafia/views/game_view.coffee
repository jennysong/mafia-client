class Mafia.GameView extends Mafia.View
  id: 'mafia-game-view'
  className: 'game-view'
  template: _.template '''
    <div class="game-view-header">
      <div class="timer"></div>
      <div class="section-tab">
        <a class="change-section primary block btn" data-section="vote">Vote</<a>
        <a class="change-section primary block btn" data-section="chat">Chat</<a>
        <a class="change-section primary block btn" data-section="role">Role</<a>
      </div>
    </div>
    <div class="game-view-body"></div>
  '''

  sections:
    chat: 'ChatView'
    vote: 'VoteView'
    role: 'RoleView'

  initialize: ->
    @users = @collection
    @_render()
    @_position()
    @_refresh_section 'chat'

  events:
    'click .change-section': 'change_section'

  _render: ->
    @$el.html @template()
    @$section_wrap = @$(".game-view-body")

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


