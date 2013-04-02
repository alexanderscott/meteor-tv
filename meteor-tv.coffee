###
# MAIN PROCESS - CLIENT/SERVER
###


Videos = new Meteor.Collection 'videos'
Couches = new Meteor.Collection 'couches'
Chats = new Meteor.Collection 'chats'



##################     SAMPLE DATA     ########################

sampleVideos = [
    {
        "fid"       : "J7LXSB4jwVI",
        "source"    : "youtube",
        "name"      : "vid1",
        "duration"  : "100",
        "cloud_id"  : ""
    },
    {
        "fid"       : "EKdcj8cv75k",
        "source"    : "youtube",
        "name"      : "vid2",
        "duration"  : "100",
        "cloud_id"  : ""
    },
    {
        "fid"       : "Fss3Xn5dZzU",
        "source"    : "youtube",
        "name"      : "vid3",
        "duration"  : "100",
        "cloud_id"  : ""
    }

]

sampleUsers = [
    {
        "name" : Random.id(),
        "cloud_id"  : "",
        "status"    : "idle"
    },
    {
        "name" : Random.id(),
        "cloud_id"  : "",
        "status"    : "idle"
    }
    {
        "name" : Random.id(),
        "cloud_id"  : "",
        "status"    : "idle"
    }
]

sampleCouches = [
    {
        "name"      : "Hot Jams"
    },
    {
        "name"      : "Valencia Beats"
    }
]

