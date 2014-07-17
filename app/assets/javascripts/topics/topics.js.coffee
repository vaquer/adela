#= require topics/initializer
#= require topics/topic_form
#= require topics/topic_loader

$ ->
  $('.edit-tools a.edit').on("click", (e) ->
    e.preventDefault()
  )

  $(document).on("ajax:success", '.edit-tools a.delete', () ->
    topics_by_day = $(this).closest("div.day-topics-holder").find(".topic-item").length
    if topics_by_day > 1
      $(this).closest("div.topic-item").remove()
    else
      $(this).closest("div.day-holder").remove()
  )

  $(".expandable").expander({
    slicePoint: 200,
    expandSpeed: 0,
    expandText: 'Ver más',
    userCollapseText: 'Ver menos'
  })