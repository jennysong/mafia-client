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
          <input name='username' type="text" class="field" placeholder="Username">
        </div>
      </div>
      <div class="row">
        <div class="columns">
          <div class="description">
            Room Number
          </div>
          <input name='room_number' type="number" class="number field" placeholder="Number">
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

  login: ->
    @user = new Mafia.Models.User @$form.serializeObject()

    @_render_waiting_view()

    false

  _render_waiting_view: ->
    new Mafia.WaitingView app: @app, parent: this, model: @user

  _render: ->
    @$el.html @template()
    @$form = @$("form")

