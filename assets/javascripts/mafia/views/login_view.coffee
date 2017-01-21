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
          <input name='user[email]' type="email" class="field" placeholder="Email Address">
        </div>
      </div>
      <div class="row">
        <div class="columns">
          <div class="description">
            Room Number
          </div>
          <input name='room-number' type="number" class="number field" placeholder="Number">
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
    console.log @$form.serializeObject()

  _render: ->
    @$el.html @template()
    @$form = @$("form")

  _position: ->
    @app.view.append_view this
