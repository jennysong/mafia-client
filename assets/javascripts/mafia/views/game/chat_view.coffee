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
    @user     = @parent.model
    @messages = @parent.messages

    @_render()
    @_render_messages()
    @_position()

    @listenTo @messages, 'add', (message) =>
      new_message_view = @_render_message message
      @_scroll_to new_message_view


    last_message = @messages.last()
    @_scroll_to last_message.view, no_animation: true if last_message



  events:
    'submit': 'send'


  send: (e) ->
    e.preventDefault()
    if message = @$input_field.val()
      @app.socket.emit "new message", @$input_field.val()
      @$input_field.val('')

  _scroll_to: (message_item_view, options = {}) ->
    return unless message_item_view
    scroll_amount = @_get_scroll_amount message_item_view
    unless options.no_animation
      @$message_list.animate scrollTop: scroll_amount
    else
      @$message_list.scrollTop scroll_amount

  _get_scroll_amount: (message_item_view) ->
    message_item_view.$el.offset().top + @$message_list.scrollTop()


  _render: ->
    @$el.html @template()
    @$input_field  = @$("[name=chatInput]")
    @$message_list = @$(".message-list")
    @$el.addClass if @user.get('alive') then 'user-alive' else 'user-died' unless @parent.finished


  _render_messages: ->
    @messages.each (message) =>
      @_render_message message


  _render_message: (message) ->
    @new Mafia.Game.Chat.MessageItemView,
      app: @app, parent: this, model: message,
      $wrap: @$message_list


  _position: ->
    @parent.$section_wrap.append @$el






