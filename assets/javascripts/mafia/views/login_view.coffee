class Mafia.LoginView extends Mafia.View
  id: 'mafia-login-view'
  className: 'login-view'
  template: _.template '''
    <form>
      <div class="logo">
        <div class="main-text">The Mafia</div>
        <div class="sub-text">Deep in the Night</div>
      </div>
      <div class="avatar-wrap">
        <span class='mafia-avatar type-<%- avatarId %> round size-large bg-<%- avatarBg %>'></span>
      </div>
      <div class="field-row">
        <input name='userName' type="text" class="field" placeholder="Username">
      </div>
      <div class="field-row">
        <input name='roomId' type="number" class="number field" placeholder="Number">
      </div>
      <div class="field-row">
        <input type='submit' class='login primary block btn' value='Login'/>
      </div>
    </form>
  '''

  events:
    'submit': 'login'

  initialize: ->
    @user = new Mafia.Models.User
    @user.setRandomAvatar()
    @_render()
    @_position()

  login: (e) ->
    e.preventDefault()
    oUser = @$form.serializeObject()
    @user.set oUser
    @app.socket.emit('user join', @user.toJSON());
    localStorage.setItem("roomId", oUser.roomId);
    @app.current_user = @user

    @_render_waiting_view()

  _render_waiting_view: ->
    new Mafia.WaitingView app: @app, parent: this, model: @user

  _render: ->
    @$el.html @template @user.toJSON()
    @$form = @$("form")

  _position: ->
    @app.view.append_view this