class Mafia.Dialogs.DialogView extends Mafia.View
  className: 'mafia-dialog-content'
  dialog_options: {}
  default_dialog_options:
    auto_show: true
    easy_close: true

  _dialog_template: _.template '''
    <div class="mafia-dialog-view dialog-hide">
      <div class="mafia-dialog-modal"></div>
    </div>
  '''

  constructor: (options) ->
    {@app} = options
    _(@dialog_options).defaults @default_dialog_options
    @$dialog_el = $ @_dialog_template()
    @dialog_el  = @$dialog_el[0]
    $("body").append @dialog_el
    _(@events).defaults @_dialog_events
    super
    @$dialog_el.append @el
    @$dialog_el.on 'click', '.close-dialog', => @close()
    @$dialog_el.find('.mafia-dialog-modal').addClass 'close-dialog' if @dialog_options.easy_close
    @show() if @dialog_options.auto_show

  events: {}

  close: ->
    @hide()
    @remove()
    @$dialog_el.remove()


  show: ->
    @$el.addClass('dialog-show').removeClass 'dialog-hide'

  hide: ->
    @$el.addClass('dialog-hide').removeClass 'dialog-show'