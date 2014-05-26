class Topics.Item
  template: JST["topics/item"]

  constructor: (@data) ->
    @form # needs to be pre-declared so that ||= works in @_show_form()
    @item = $ @template(topic: @data)
    @_setup_events(@item)

  load_in: (container) ->
    @item.hide()
    $(container).append(@item)
    @item.fadeIn()

  _setup_events: (item) ->
    item.find(".edit-tools .edit").click (e) =>
      e.preventDefault()
      @_hide_item_data()
      @_show_form()

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

