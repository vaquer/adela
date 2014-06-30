$ ->
  $("#view_more").on("click", (e) ->
    e.preventDefault()
    $(".more-activities").removeClass("hidden")
    $(this).addClass("hidden")
  )

  $("#view_less").on("click", (e) ->
    e.preventDefault()
    $(".more-activities").addClass("hidden")
    $(this).addClass("hidden")
    $("#view_more").removeClass("hidden")
  )