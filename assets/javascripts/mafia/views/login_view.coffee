class Mafia.LoginView extends Mafia.View
  id: 'mafia-login-view'
  className: 'login-view'
  template: _.template '''
    <form>
      <div class="row">
        <div class="columns">
          <div class="description">
            Username
          </div>
          <input name='userName' type="text" class="field" placeholder="Username">
        </div>
      </div>
      <div class="row">
        <div class="columns">
          <div class="description">
            Room Number
          </div>
          <input name='roomId' type="number" class="number field" placeholder="Number">
        </div>
      </div>
      <input type='submit' class='login primary block btn' value='Login'/>
    </form>
  '''

  events:
    'submit': 'login'

  initialize: ->
    @_render()
    @_position()

  login: (e) ->
    e.preventDefault()
    oUser = @$form.serializeObject()

    @app.socket.emit('user join', oUser);
    localStorage.setItem("roomId", oUser.roomId);

    @user = new Mafia.Models.User oUser

    @_render_waiting_view()

  _render_waiting_view: ->
    new Mafia.WaitingView app: @app, parent: this, model: @user

  _render: ->
    @$el.html @template()
    @$form = @$("form")

  _position: ->
    @app.view.append_view this