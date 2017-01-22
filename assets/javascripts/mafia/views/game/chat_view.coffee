class Mafia.Game.ChatView extends Mafia.View
  id: 'mafia-game-chat-view'
  template: _.template '''
    Chat View
    <div>
      <ul name="chatMsgs"></ul>
      <form>
        <input name="chatInput" autocomplete="off" />
        <input type='submit' value='Send' />
      </form>
    </div>
  '''
  events:
    'submit': 'send'

  initialize: ->
    @_render()
    @_position()
    @app.socket.on "update message", (oMsg) ->
      $("[name=chatMsgs]").append $('<li>').text(oMsg.writer + ": "+ oMsg.msg)

  send: (e) ->
    console.log("press")
    e.preventDefault()
    @app.socket.emit "new message", $("[name=chatInput]").val()
    $("[name=chatInput]").val('')


  _render: ->
    @$el.html @template()

  _position: ->
    @parent.$section_wrap.append @$el