###
# YOUTUBE PLAYER HELPER LIB 
###


YouTubePlayer = YouTubePlayer or null

# Helper for player state status string
playerState =
    '-1': 'UNSTARTED',
    '0' : 'ENDED',
    '1' : 'PLAYING',
    '2' : 'PAUSED'
    '3' : 'BUFFERING',
    '5' : 'CUED'
    
# Playback controls
stopVideo = -> YouTubePlayer.stopVideo
playVideo = -> YouTubePlayer.playVideo
pauseVideo = -> YouTubePlayer.pauseVideo

# Get playback info
getVideoDuration = -> YouTubePlayer.getDuration
getVideoTimeElapsed = -> YouTubePlayer.getCurrentTime
getPlayerState = -> YouTubePlayer.getPlayerState


initYouTube = ->
    params =
        allowScriptAccess: 'always'
    atts =
        id: 'player',
        wmode: 'transparent'

    swfobject.embedSWF(
        'http://www.youtube.com/apiplayer?enablejsapi=1&playerapiid=player&version=3',
        'ytapiplayer', '640', '390', '8', null, null, params, atts
    )



onYouTubePlayerReady = (playerId) ->
    console.log 'YOUTUBE: player ready'
    $('.video-wrapper').fitVids()
    YouTubePlayer = document.getElementById(playerId)
    YouTubePlayer.addEventListener('onStateChange', onPlayerStateChange)


onPlayerStateChange = (event) ->
    console.log 'YT.PlayerState changed to ', playerState[event.data]

onPlayerError = (event) ->
    console.log 'YT.Player Error: ', event.data



# Return youtube id from a URL
getVideoIDFromURL = (ytUrl) ->
    ytUrl = ytUrl || ""      #make sure it's a string; sometimes the YT player API returns undefined, and then indexOf() below will fail
    qryParamsStart = ytUrl.indexOf "?"
    qryParams = ytUrl.substring(qryParamsStart, ytUrl.length)
    videoStart = qryParams.indexOf "v="

    if videoStart > -1
        videoEnd = qryParams.indexOf("&", videoStart)
        if videoEnd is -1
            videoEnd = qryParams.length
        return qryParams.substring(videoStart+"v=".length, videoEnd)
    
    return ""



checkYouTubeUrl = (ytUrl) ->
    parsedId = getVideoIDFromURL(ytUrl)
    console.log 'YOUTUBE: Inserting video: ', parsedId

    if parsedId isnt ''
        Videos.insert
            fid : parsedId,
            source : 'youtube',
            name : Random.id(),
            duration: 100
    else
        $('#video-input-label').text 'Not a valid YouTube URL'
        $('.control-group').addClass 'error'



searchYouTube = (query, callback) ->
    $.getJSON('https://gdata.youtube.com/feeds/api/videos?callback=?',
            q: query,
            alt: 'jsonc',
            v: '2',
            format: '5'
        callback
    )
