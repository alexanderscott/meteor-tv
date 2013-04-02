###
# CLIENT MAIN PROCESS
###


##################      CONSTANTS       ########################
CLIENT_KEEP_ALIVE_INTERVAL = (20 * 1000)    # 20 seconds
CLIENT_POLL_INTERVAL = (3 * 1000)                  # 3 seconds
CLIENT_UPDATE_INTERVAL = (10 * 1000)               # 10 seconds


##################      SUBSCRIBES       ########################
Meteor.subscribe 'users_active'
Meteor.subscribe 'couchs'
Meteor.subscribe 'couch_users'
Meteor.subscribe 'couch_videos'
Meteor.subscribe 'couch_chats'


##################    TEMPLATE BINDINGS   ########################
#Template.screen.vidID = -> sampleVideos[0].fid
#Template.screen.origin = -> document.location.protocol+'//'+document.location.hostname

Template.queue.queue = -> Videos.find()

Template.sidenav.events =
    'keyup #video-input': (evt) ->
        if evt.which is 13
            checkYouTubeUrl $('#video-input').val()
    'click #video-submit': (evt) ->
        checkYouTubeUrl $('#video-input').val()



###
Play the first video and remove from the collection
If it doesn't exist then set this in the Session
###
cyclePlaylist = ->
    console.log 'cyclePlaylist'
    video = Videos.findOne()
    console.log video
    if video
        Session.set('playing_video', video)
        Videos.remove(video._id)
        if YouTubePlayer then YouTubePlayer.loadVideoById( video.fid )
    else Session.set('playing_video', '')



##################      POLLING       ########################
# Poll the YouTube Player for changes in player state and update Session time
# If the player has not started, then begin playing the playlist
pollActiveUsers = ->
    Meteor.setInterval( ->
        if YouTubePlayer
            state = YouTubePlayer.getPlayerState()
            if state is 0 then cyclePlaylist()                  #ended
            else if state is -1 or state is 5 or state is 2 then cyclePlaylist()  #not started
            #else if state is 1 or state is 3                    #playing or buffering, do nothing

    CLIENT_POLL_INTERVAL
    )

    Meteor.setInterval( ->
        if YouTubePlayer
             state = YouTubePlayer.getPlayerState
            #if state is 0 then updateTime
    CLIENT_UPDATE_INTERVAL
    )



##################    BACKBONE ROUTER   ########################
couchVideosRouter = Backbone.Router.extend(
    routes:
        "" : "routeHome",
        ":couchId": "routeCouch"

    routeHome: ->
        firstcouch = Couches.findOne()
        console.log 'ROUTER: Initially routing to couch ', firstcouch.fetch()

        @setcouch(firstcouch._id)  # Route to couch's page
        #Deps.flush()
        

    routeCouch: (couchId) ->
        Session.set('current_couch_id', couchId)
        Session.set('selected_video', null)
        Meteor.users.update(
            Session.get('current_user_id'), {$set:{couch_id: couchId}}
        )

        Deps.flush()
        initYouTube()

    setcouch: (couchId) -> @navigate(couchId, true)
)

Router = new couchVideosRouter()





##################    INITIALIZE CLIENT    ######################## 

Meteor.startup(->
    console.log 'cj-client startup'

    #Deps.autorun(->
        #if !Session.get('selected')
            #console.log 'not logged in'
    #)

    initYouTube()

    pollActiveUsers()      # intialize the player and poll for changes

    Backbone.history.start({ pushState : true })

    Deps.flush()      # refresh the DOM
)

