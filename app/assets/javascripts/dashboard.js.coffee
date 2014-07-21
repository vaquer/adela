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

  $(document).on("pjax:timeout", () ->
    false
  )

  $("#calendar").on("pjax:start", () ->
    spinner = new Spinner({color:'#999999', lines: 11, width: 3}).spin()
    $("#calendar-header").html("")
    $("#calendar-content").html(spinner.el)
  )

  $("#organizations").on("pjax:start", () ->
    spinner = new Spinner({color:'#999999', lines: 11, width: 3}).spin()
    $("#organizations").html(spinner.el)
  )

  $(document).pjax(".calendar-nav-bar a, a.calendar-navigation-link", '[data-pjax-container]')
  $(document).pjax("#organizations_links .pagination a", '#organizations')