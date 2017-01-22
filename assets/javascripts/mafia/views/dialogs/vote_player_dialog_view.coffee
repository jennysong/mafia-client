class Mafia.Dialogs.VotePlayerDialogView extends Mafia.Dialogs.DialogView
  id: 'vote-player-dialog'
  template: _.template '''
    <div class="dialog-title">Vote a Player</div>
    <div class="dialog-body">
      <div class="users-list"></div>
    </div>
  '''
  initialize: (options) ->
    {@after_select, @users, @current_user} = options
    @_render()
    @_render_users()


  _render: ->
    @$el.html @template()
    @$user_list = @$(".users-list")

  _render_users: ->
    @users.each (user) =>
      if (user.id != @current_user.id) and user.get("alive")
        @new Mafia.Dialogs.VotePlayerDialog.UserItemView,
          app: @app, parent: this, model: user
          $wrap: @$user_list, after_select: @after_select