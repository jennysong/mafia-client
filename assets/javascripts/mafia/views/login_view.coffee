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

      </div>
      <div class="field-row">
        <input name='userName' type="text" class="field" value="<%- userName %>" placeholder="Username">
      </div>
      <div class="field-row">
        <input name='roomId' type="number" class="number field" placeholder="Number">
      </div>
      <div class="field-row">
        <input type='submit' class='login primary block btn' value='Login'/>
      </div>
    </form>
  '''

  avatar_template: _.template '''
    <span class='mafia-avatar type-<%- avatarId %> round size-large bg-<%- avatarBg %>'></span>
  '''

  initialize: ->
    @user = new Mafia.Models.User @app.current_user.toJSON()
    @user.setRandomAvatar() unless @user.get('avatarId')
    @_render()
    @_render_avatar()
    @_position()



  events:
    'submit': 'login'
    'click .mafia-avatar': 'reroll_avatar'


  reroll_avatar: ->
    @user.setRandomAvatar()
    @_render_avatar()

  login: (e) ->
    e.preventDefault()
    oUser = @$form.serializeObject()
    @user.set oUser
    @app.socket.emit('user join', @user.toJSON());

  _render_waiting_view: ->
    new Mafia.WaitingView app: @app, parent: this, model: @user

  _render: ->
    @$el.html @template @user.toJSON()
    @$form = @$("form")
    @$avatar_wrap = @$(".avatar-wrap")

  _render_avatar: ->
    @$avatar_wrap.html @avatar_template @user.toJSON()

  _position: ->
    @app.view.append_view this

  remove: ->
    @app.socket.off 'user joined'
    @app.socket.off 'game already started'
    super