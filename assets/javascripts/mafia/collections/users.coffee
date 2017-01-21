class Mafia.Collections.Users extends Backbone.Collection
  model: Mafia.Models.User
  sampleUserName: ['Youn', 'Lucia', 'Jenny', 'Shawn', 'Sunny', 'Suyeon', 'Alan', 'Annie', 'Harry', 'Catherine']

  addFakeUsers: ->
    _(@sampleUserName).each (name) =>
      model = new @model userName: name, roomId: 1
      model.setRandomAvatar()
      @add model