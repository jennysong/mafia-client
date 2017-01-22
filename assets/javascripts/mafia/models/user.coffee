class Mafia.Models.User extends Backbone.Model
  bgColors: ['olive', 'orange', 'crimson', 'pink', 'purple', 'blue', 'sky', 'babyblue', 'emerald', 'grass', 'lime', 'red']
  defaults:
    userName: null
    roomId: null
    avatarId: 0
    avatarBg: null
    userStatus: false
    role: null



  setRandomAvatar: ->
    @set
      avatarId: _.random(1,12)
      avatarBg: _(@bgColors).sample()