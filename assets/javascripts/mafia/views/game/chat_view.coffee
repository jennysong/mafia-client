class Mafia.Game.ChatView extends Mafia.View
  id: 'mafia-game-chat-view'
  template: _.template '''
    <div class="message-list"></div>
    <div class="message-actions">
      <form>
        <div class="bullet"><span class="entypo comment"></span></div>
        <input type='text' name="chatInput" autocomplete="off" />
        <input type='submit' value='Send' />
      </form>
    </div>

  '''

  initialize: ->
    @messages = @parent.messages
    @_render()
    @_render_messages()
    @_position()

    @listenTo @messages, 'add', (message) =>
      new_message_view = @_render_message message
      @_scroll_to new_message_view

  events:
    'submit': 'send'


  send: (e) ->
    e.preventDefault()
    if message = @$("[name=chatInput]").val()
      @app.socket.emit "new message", @$("[name=chatInput]").val()
      @$("[name=chatInput]").val('')

  _scroll_to: (message_item_view) ->
    @$message_list.animate scrollTop: message_item_view.$el.offset().top + @$message_list.scrollTop()


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






