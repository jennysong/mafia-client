class Mafia.Dialogs.GameResultDialogView extends Mafia.Dialogs.DialogView
  id: 'mafia-game-start-dialog'
  className: ''
  template: _.template '''
    <div class="text">
      <%- userName %> is dead.
      <%- userName %> is a <span class="role"><%- role %>.</span>
    </div>
  '''

  initialize: (options) ->
    {@after_show} = options
    @_render()

    @_timeout = setTimeout =>
      @close()
    , 4000

  events:
    'click': "close"

  _render: ->
    @$el.html @template @model.toJSON()
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