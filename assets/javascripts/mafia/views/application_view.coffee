class Mafia.ApplicationView extends Mafia.View
  id: 'mafia-application-view'
  className: 'application-view'
  template: _.template '''
    <div class="row">
      <div class="medium-8 push-2 columns">
        <div id="application-body"></div>
        <div id="application-footer">
          <div class="made-by">
            Made by Shawn, Jenny, and Youn
          </div>
        </div>
      </div>
    </div>
  '''

  initialize: ->
    @_render()
    @_render_header()
    @_position()

  append_view: (view) ->
    @_current_view.remove() if @_current_view
    @_current_view = view
    @$body.append view.el
    @$doc_body.scrollTop 0

  _render: ->
    @$el.html @template
    @$body = @$("#application-body")
    @$doc_body = $("body")

  _render_header: ->
    @header_view = new Mafia.Application.HeaderView app: @app, parent: this

  _position: ->
    @$el.appendTo @$doc_body