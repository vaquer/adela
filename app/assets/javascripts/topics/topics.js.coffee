#= require topics/initializer
#= require topics/topic_form

$ ->

  $(document).on("click", '.edit-tools a.edit', (e) ->
    e.preventDefault()
    $("#edit-topic-container").html("")
    topic_id = $(this).attr("id").split("-")[2]
    $.getJSON "/topics/" + topic_id, (data) =>
      form = new Topics.Form
        data: data
        form_container: "#edit-topic-container"
      form._show_form()
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