$ ->
  $("form#requirements").on("change", "input.requirement", validate_requirements)

  $("#save_inventory").on("click", show_last_step)

  $("form#new_inventory").on("change", "#inventory_csv_file", () ->
    $("#upload_file[type=submit]").removeClass("disabled")
  )

validate_requirements = () ->
  checked_requirements = $(this).closest("form#requirements").find("input.requirement:checked")
  submit_button = $(this).closest("form#requirements").find("input#publish[type=submit]")
  if checked_requirements.length == $(this).closest("form#requirements").find("input.requirement").length
    submit_button.removeClass("disabled")
  else
    submit_button.addClass("disabled")

show_last_step = () ->
  $("#save_inventory").addClass("hidden")
  $(".preview-table").closest(".step-holder").addClass("inventory-step")
  $("#publish_inventory, .publish-form-holder").removeClass("hidden")
  $(".checked-step").removeClass("hidden")
  false