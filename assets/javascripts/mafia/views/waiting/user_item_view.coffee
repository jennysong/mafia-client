class Mafia.Waiting.UserItemView extends Mafia.View
  className: "user-item"
  template: _.template '''
    <span class='mafia-avatar type-<%- avatarId %> size-medium mask-for-waiting-view'></span>
    <div class="status-bullet">
      <div class="visible-user-status-ready">
        <div class="entypo check"></div>
      </div>
    </div>
    <div class="item-name truncate"><%- userName %></div>
  '''

  initialize: (options) ->
    {@$wrap} = options

    @_render()
    @_position()

    @_init_current_status()

    @listenTo @model, 'change', @_refresh

  _refresh: ->
    @_render()
    @_init_current_status()

  _render: ->
    @$el.html @template @model.toJSON()

  _position: ->
    @$wrap.append @$el

  _init_current_status: ->
    if @model.get('userStatus') is true
      @$el.addClass('user-status-ready').removeClass('user-status-waiting')
    else
      @$el.addClass('user-status-waiting').removeClass('user-status-ready')