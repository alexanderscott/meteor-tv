Meteor.startup(->

    console.log 'server startup'

    if Videos.find().count() is 0
        Videos.insert video for video in sampleVideos

    if Players.find().count() is 0
        Players.insert player for player in samplePlayers

)

