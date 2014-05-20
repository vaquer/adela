$ ->
  $("form#requirements").on("change", "input.requirement", validate_requirements)

  $("#save_inventory").on("click", show_last_step)

validate_requirements = () ->
  checked_requirements = $("input.requirement:checked")
  if checked_requirements.length == $("input.requirement").length
    $("input#publish[type=submit]").removeClass("disabled")
  else
    $("input#publish[type=submit]").addClass("disabled")

show_last_step = () ->
  $("#save_inventory").addClass("hidden")
  $(".preview-table").closest(".step-holder").addClass("inventory-step")
  $("#publish_inventory").removeClass("hidden")
  $(".checked-step").removeClass("hidden")
  false
