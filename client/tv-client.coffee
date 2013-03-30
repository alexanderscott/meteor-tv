###
# CLIENT MAIN PROCESS
###


##################      CONSTANTS       ########################
PLAYER_KEEP_ALIVE_INTERVAL = (20 * 1000)    # 20 seconds
POLL_INTERVAL = (3 * 1000)                  # 3 seconds
UPDATE_INTERVAL = (10 * 1000)               # 10 seconds


##################      SUBSCRIBES       ########################
Meteor.subscribe 'videos'
Meteor.subscribe 'players'



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



###
Poll the YouTube Player for changes in player state and update Session time
If the player has not started, then begin playing the playlist
###
playerPoll = ->
    Meteor.setInterval( ->
        if YouTubePlayer
            state = YouTubePlayer.getPlayerState()
            if state is 0 then cyclePlaylist()                  #ended
            else if state is -1 or state is 5 or state is 2 then cyclePlaylist()  #not started
            #else if state is 1 or state is 3                    #playing or buffering, do nothing

    POLL_INTERVAL
    )

    Meteor.setInterval( ->
        if YouTubePlayer
             state = YouTubePlayer.getPlayerState
            #if state is 0 then updateTime
    UPDATE_INTERVAL
    )



###
Startup the client-side app
###
Meteor.startup(->
    console.log 'client startup'
    initYoutube()

    playerPoll()      # intialize the player and poll for changes
    Deps.flush()      # refresh the DOM
)

