class Mafia.Game.ChatView extends Mafia.View
  id: 'mafia-game-chat-view'
  template: _.template '''
    <div class="message-list"></div>
    <div class="message-actions">
      <form>
        <input name="chatInput" autocomplete="off" />
        <input type='submit' value='Send' />
      </form>
    </div>

  '''

  initialize: ->
    @messages = @parent.messages
    @_render()
    @_render_messages()
    @_position()

    @listenTo @messages, 'add', @_render_message

  events:
    'submit': 'send'


  send: (e) ->
    e.preventDefault()
    @app.socket.emit "new message", @$("[name=chatInput]").val()
    @$("[name=chatInput]").val('')


  _render: ->
    @$el.html @template()
    @$message_list = @$(".message-list")


  _render_messages: ->
    @messages.each (message) =>
      @_render_message message


  _render_message: (message) ->
    @new Mafia.Game.Chat.MessageItemView,
      app: @app, parent: this, model: message,
      $wrap: @$message_list

  _position: ->
    @parent.$section_wrap.append @$el