class Mafia.ResultView extends Mafia.View
  id: 'mafia-result-view'
  className: 'result'
  template: _.template '''
    <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer condimentum arcu et eros vulputate, rhoncus pharetra ex fermentum. Praesent suscipit gravida turpis, et laoreet libero cursus eget. In eleifend ipsum vel nisl hendrerit euismod at nec nisi. Vivamus vitae fringilla risus, sed convallis ante. Nullam convallis vestibulum tincidunt. In id sapien eget lectus finibus tincidunt eget eu est. Mauris tristique, urna sit amet viverra maximus, neque nunc efficitur libero, sed lacinia est magna non augue. Etiam ornare efficitur accumsan. Vivamus tincidunt tortor enim, dignissim aliquet quam tempor ac. Aliquam auctor, purus in consequat facilisis, ex tellus vestibulum odio, euismod feugiat risus nulla vel enim. Sed ac tortor ut massa laoreet ultricies. Curabitur varius eros at ipsum feugiat, ut porttitor felis consequat. Duis placerat purus sapien, sit amet aliquet odio sollicitudin eget. Maecenas dui purus, euismod sit amet commodo at, aliquam a sem. Fusce vestibulum ut lectus in rhoncus. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas.</p>
  '''

  events:
    'click': 'open_game_view'

  initialize: (options = {}) ->
    {@report} = options
    @_render()
    @_position()

  _render: ->
    @$el.html @template @report

  open_game_view: ->
    console.log "change to game view"