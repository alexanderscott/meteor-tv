Meteor.publish('videos', -> Videos.find())
Meteor.publish('players', -> Players.find({ idle : false }))

