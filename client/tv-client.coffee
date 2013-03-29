Meteor.subscribe 'videos'
Meteor.subscribe 'players'

Template.screen.vidID = -> sampleVideos[0].fid
Template.screen.origin = -> document.location.protocol+'//'+document.location.hostname

Template.queue.queue = -> Videos.find()

Template.sidenav.events =
    #'click .btn': ->
        #console.log 'clicked refresh button'
        #$('.video-wrapper').tubeplayer('play', sampleVideos[1].fid)
    'keyup #video-input': (evt) ->
        if evt.which is 13
            checkYouTubeUrl $('#video-input').val()
    'click #video-submit': (evt) ->
        checkYouTubeUrl $('#video-input').val()


Meteor.startup(->
    console.log 'client startup'
    #$('#player').fitVids()
)

