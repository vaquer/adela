class window.TopicForm
  template: JST["topics/form"]

  constructor: (opts) ->
    @new_button = $ opts.new_button
    @form_container = $ opts.form_container
    @topics_listing = $ opts.topics_listing

    @_find_elements()
    @_setup_events()

  _find_elements: ->
    template = $ @template()

    @form = template.find("form")
    @submit_button = template.find("button[type=submit]")
    @cancel = template.find("a")
    @topic_name = template.find("#topic_name")
    @topic_owner = template.find("#topic_owner")
    @topic_description = template.find("#topic_description")

    @form_container.hide()
    @form_container.append(template)

  _setup_events: () ->
    @new_button.click (e) =>
      e.preventDefault()
      @_hide_form()
    @cancel.click (e) =>
      e.preventDefault()
      @_show_form()
    @form.submit @_handle_form_submit

  _show_form: () ->
    @form_container.hide()
    @new_button.show()

  _hide_form: () ->
    @new_button.hide()
    @form_container.fadeIn()

  _handle_form_submit: (e) =>
    e.preventDefault()
    jqxhr = $.post "/topics", @_post_data(), @_post_success, "json"
    jqxhr.fail @_post_fail

  _post_data: () ->
    topic:
      name: @topic_name.val().trim()
      owner: @topic_owner.val().trim()
      description: @topic_description.val().trim()

  _post_success: (data, status) =>
    @_clear_field_errors()
    @_clear_form_fields()
    @_add_new_topic(data)
    @_hide_form()

  _post_fail: (jqXHR, status) =>
    @_clear_field_errors()
    errors = jqXHR.responseJSON && jqXHR.responseJSON.errors
    if errors && errors.name && errors.name.length > 0
      @topic_name.parents(".form-group").addClass("has-error")
      @topic_name.parent("div").addClass("has-error")
    if errors && errors.owner && errors.owner.length > 0
      @topic_owner.parents(".form-group").addClass("has-error")
      @topic_owner.parent("div").addClass("has-error")

  _add_new_topic: (data) ->
    new_topic = $ JST["topics/item"](topic: data)
    new_topic.hide()
    @topics_listing.append new_topic
    new_topic.fadeIn()

  _clear_field_errors: () ->
    @topic_name.parents(".form-group").removeClass("has-error")
    @topic_name.parent("div").removeClass("has-error")
    @topic_owner.parents(".form-group").removeClass("has-error")
    @topic_owner.parent("div").removeClass("has-error")

  _clear_form_fields: () ->
    @topic_name.val ""
    @topic_owner.val ""
    @topic_description.val ""
