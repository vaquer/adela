class Topics.Item
  template: JST["topics/item"]

  constructor: (@data) ->
    @form # needs to be pre-declared so that ||= works in @_show_form()
    @item = $ @template(topic: @data)
    @_setup_events(@item)
    @_setup_text_expander(@item)

  load_in: (container) ->
    @item.hide()
    $(container).append(@item)
    @item.fadeIn()
    $("#save_plan").removeClass("hidden")

  _setup_events: (item) ->
    item.find(".edit-tools .edit").click (e) =>
      e.preventDefault()
      @_hide_item_data()
      @_show_form()
    item.find(".edit-tools .delete").bind("ajax:success", () ->
      item.remove()
      if $("#topics-listing").find(".topic-data").length == 0
        $("#save_plan").addClass("hidden")
      index = 1
      $("#topics-listing").find(".sort-order").each () ->
        $(@).find("strong").hide().delay(100).text(index).fadeIn()
        index += 1
    )

  _setup_text_expander: (item) ->
    item.find(".expandable").expander({
      slicePoint: 200,
      expandSpeed: 0,
      expandText: 'Ver más',
      userCollapseText: 'Ver menos'
    })

  _show_form: () ->
    @form ||= new Topics.Form
      data: @data
      form_container: "#topic-#{@data.id}-form-container"
      success_callback: @_replace_item
      cancel_callback: @_show_item_data
    @form._show_form()

  _hide_item_data: () =>
    @item.find(".topic-data").hide()

  _show_item_data: () =>
    @item.find(".topic-data").fadeIn()

  _replace_item: (data) =>
    new_item = new Topics.Item(data)
    new_container = $ "<div></div>"

    @item.after new_container
    new_item.load_in(new_container)
    @item.remove()

