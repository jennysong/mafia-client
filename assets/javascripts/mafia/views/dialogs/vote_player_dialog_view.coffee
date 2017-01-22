class Mafia.Dialogs.VotePlayerDialogView extends Mafia.Dialogs.DialogView
  id: 'vote-player-dialog'
  template: _.template '''
    <div class="dialog-title">Vote a Player</div>
    <div class="dialog-body">
      <div class="users-list"></div>
    </div>
  '''
  initialize: (options) ->
    {@after_select, @users} = options
    @_render()
    @_render_users()


  _render: ->
    @$el.html @template()
    @$user_list = @$(".users-list")

  _render_users: ->
    @users.each (user) =>
      @new Mafia.Dialogs.VotePlayerDialog.UserItemView,
        app: @app, parent: this, model: user
        $wrap: @$user_list