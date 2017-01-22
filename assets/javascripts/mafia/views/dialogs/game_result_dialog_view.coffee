class Mafia.Dialogs.GameResultDialogView extends Mafia.Dialogs.DialogView
  id: 'mafia-game-start-dialog'
  className: ''
  template: _.template '''
    <div class="text">
      <%- userName %> is dead.
      <%- userName %> is a <span class="role"><%- role %>.</span>
    </div>
  '''
  none_dead_template: _.template '''
    <div class="text">
      Goob Job, Doctor.
      None is <span class="role">dead.</span>
    </div>
  '''

  initialize: (options) ->
    {@after_show} = options
    @_render()

    @_timeout = setTimeout =>
      @close()
    , 4000
    # @_give_information_to_cop if @app.current_user.get("role") is "police"

  events:
    'click': "close"

  _render: ->
    if @model
      @$el.html @template @model.toJSON()
    else
      @$el.html @none_dead_template()

    @$role = @$(".role")
    @$role.css 'opacity', 0

  show: ->
    @$dialog_el.css 'opacity', 0
    super
    @$dialog_el.transition opacity: 1, 1200, =>
      @$role.transition opacity: 1, 2000
      @after_show() if _(@after_show).isFunction()

  hide: ->
    @$dialog_el.transition opacity: 0, 1200, =>
      super

  close: ->
    clearTimeout @_timeout
    super

  # _give_information_to_cop: ->
  #   @parent.messages.add_system_message()