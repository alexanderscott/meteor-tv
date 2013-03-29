Videos = new Meteor.Collection 'videos'
Players = new Meteor.Collection 'players'


sampleVideos = [
    {
        "fid"       : "J7LXSB4jwVI",
        "source"    : "youtube",
        "name"      : "vid1",
        "duration"  : "100"
    },
    {
        "fid"       : "EKdcj8cv75k",
        "source"    : "youtube",
        "name"      : "vid2",
        "duration"  : "100"
    }
]

samplePlayers = [
    {
        "name" : Random.id(),
        "idle" : false
    },
    {
        "name" : Random.id(),
        "idle" : false
    }
]

