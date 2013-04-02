###
# MAIN PROCESS - SERVER
###


##################      CONSTANTS       ########################
SERVER_KEEP_ALIVE_INTERVAL = (30 * 1000)    # 20 seconds
IDLE_INTERVAL = (70 * 1000)                 # 70  seconds
#UPDATE_INTERVAL = (10 * 1000)               # 10 seconds



##################      PUBLICATIONS       ########################
Meteor.publish('couches', -> Couches.find())

Meteor.publish('couch_users', (couchId) ->
    Meteor.users.find(
        couch_id : couchId,
        status : "active"
        #status : {$ne:{status:"idle"}}
    )
)

Meteor.publish('couch_videos', (couchId) ->
    Couches.find(
        couch = Couches.findOne(couchId)
        if couch then Videos.find({couch_id: couchId})
    )
)

Meteor.publish('users_active', -> Meteor.users.find({ status : 'active' }))
#Meteor.publish('user_self', (userId) -> Users.find(userId))
Meteor.publish('couch_chats', (couchId) -> Chats.find({couch_id : couchId}))



##################     METHODS        ########################
Meteor.methods(->
    # Keep track of who is logged in
    keepAlive: (userId) ->
        Meteor.users.update({ _id : userId }, {$set:{ last_keepalive : (new Date()).getTime(), status : "active"}})

)



##################      POLLING       ########################
Meteor.setInterval(->
    now = (new Date()).getTime()
    idleThreshold = now - IDLE_INTERVAL

    idleUsers = Meteor.users.find({ status: "active", last_keepalive: {$lt: idleThreshold}}).fetch()

    Meteor.users.update(idle._id, {$set:{status:"idle"}}) for idle in idleUsers
SERVER_KEEP_ALIVE_INTERVAL)



##################    INITIALIZE CLIENT    ######################## 
Meteor.startup(->
    console.log 'tv-server startup'

    # Configure login services at runtime
    Accounts.loginServiceConfiguration.remove(
        service: {$in: ["twitter", "facebook"]}
    )

    Accounts.loginServiceConfiguration.insert(
        service: "twitter",
        consumerKey: apiKeys.twitter.key,
        secret: apiKeys.twitter.secret
    )

    Accounts.loginServiceConfiguration.insert(
        service: "facebook",
        consumerKey: apiKeys.facebook.key,
        secret: apiKeys.twitter.secret
    )

    # Populate sample data if there is none
    if Couches.find().count() is 0
        Couches.insert couch for couch in sampleCouches

    if Videos.find().count() is 0
        Videos.insert video for video in sampleVideos

    if Meteor.users.find().count() is 0
        Meteor.users.insert user for user in sampleUsers

)

