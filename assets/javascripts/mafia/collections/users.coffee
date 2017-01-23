class Mafia.Collections.Users extends Backbone.Collection
  model: Mafia.Models.User
  sampleUserName: ['Youn', 'Lucia', 'Jenny', 'Shawn', 'Sunny', 'Suyeon', 'Alan', 'Annie', 'Harry', 'Catherine']

  addFakeUsers: ->
    _(@sampleUserName).each (name) =>
      model = new @model userName: name, roomId: 1
      model.setRandomAvatar()
      @add model

  addEmptySlots: (count) ->
    _(count).times => @add {}

  updatesCollectionByIndex: (array) ->
    _(array).each (attrs, index) =>
      model = @at index
      if model
        model.set attrs
      else
        model = new @model attrs
        @add model

  isReady: ->
    users_without_empty_slot = @select (user) -> user.id
    return false if users_without_empty_slot.length < 3
    _(users_without_empty_slot).every (user) -> user.get('userStatus')

  check_and_reset_votes: ->
    @each (user) =>
      user.set {
        "generalVote": null
        "specialVote": null
      }