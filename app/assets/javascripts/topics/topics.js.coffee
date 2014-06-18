#= require topics/initializer
#= require topics/topic_item
#= require topics/topic_form
#= require topics/topic_loader

$ ->
  $("#start_adding_topics")
    .animate({right: '-15px'}, 500).delay(500)
    .animate({right: '15px'}, 500).delay(500)
    .animate({right: '0px'}, 500)

  $("#new-topic-button").click (e) ->
    $("#start_adding_topics").remove()