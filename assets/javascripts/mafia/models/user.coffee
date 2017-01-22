class Mafia.Models.User extends Backbone.Model
  bgColors: ['olive', 'orange', 'crimson', 'pink', 'purple', 'blue', 'sky', 'babyblue', 'emerald', 'grass', 'lime', 'red']
  defaults:
    userName: null
    roomId: null
    avatarId: 0
    avatarBg: null
    userStatus: false
    role: null
    id: null
    alive: true
    generalVote: null
    specialVote: null

  MAFIA_WIN_SCENE_NUMBER:    666
  VILLAGER_WIN_SCENE_NUMBER: 999

  setRandomAvatar: ->
    @set
      avatarId: _.random(1,12)
      avatarBg: _(@bgColors).sample()


