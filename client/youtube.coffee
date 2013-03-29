
# async script insertion
tag = document.createElement('script')
tag.src = "https://www.youtube.com/iframe_api"
firstScriptTag = document.getElementsByTagName('script')[0]
firstScriptTag.parentNode.insertBefore(tag, firstScriptTag)

# This function creates an <iframe> (and YouTube player)
#    after the API code downloads.
onYouTubeIframeAPIReady = ->
    console.log 'js on youtube iframe api ready'
    $('.video-wrapper').fitVids()
    player = new YT.Player('player', {
        playerVars: {
            'autoplay': 1,
            'controls': 0,
            'showinfo': 1
        },
        #ytPlayer = new YT.Player('video-wrapper', {
        #height: '390',
        #width: '640',
        #videoId: 's6WGNd8QR-U',
        events: {
            'onReady': onPlayerReady,
            'onStateChange': onPlayerStateChange
        }
    })

# The API will call this function when the video player is ready.
onPlayerReady = (event) ->
    #$('.video-wrapper').fitVids()
    console.log 'js on player ready'
    event.target.playVideo()

#    The API calls this function when the player's state changes.
#    The function indicates that when playing a video (state=1),
#    the player should play for six seconds and then stop.
done = false
onPlayerStateChange = (event) ->
    if event.data is YT.PlayerState.PLAYING and !done
        setTimeout(stopVideo, 6000)
        done = true

stopVideo = ->
    player.stopVideo()


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
    console.log 'inserting video: ', parsedId

    if parsedId isnt ''
        Videos.insert
            fid : parsedId,
            source : 'youtube',
            name : Random.id(),
            duration: 100
    else
        $('#video-input-label').text 'Not a valid YouTube URL'
        $('.control-group').addClass 'error'


