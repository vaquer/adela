class Topics.Form
  template: JST["topics/form"]

  constructor: (opts) ->
    @show_form_button = $(opts.show_form_button) if opts.show_form_button
    @form_container = $ opts.form_container
    @success_callback = opts.success_callback || (() ->)
    @cancel_callback = opts.cancel_callback || (() ->)
    @data = opts.data || {}

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

    @_fill_in_data()
    @form_container.hide()
    @form_container.append(template)

  _setup_events: () ->
    if @show_form_button
      @show_form_button.click (e) =>
        e.preventDefault()
        @_show_form()

    @cancel.click (e) =>
      e.preventDefault()
      @_hide_form()
      @cancel_callback()

    @form.submit @_handle_form_submit

  _fill_in_data: () ->
    if @data
      @topic_name.val @data.name
      @topic_owner.val @data.owner
      @topic_description.val @data.description

  _hide_form: () ->
    @form_container.hide()
    @show_form_button.fadeIn() if @show_form_button

  _show_form: () ->
    @show_form_button.hide() if @show_form_button
    @form_container.fadeIn()


  _handle_form_submit: (e) =>
    e.preventDefault()
    jqxhr = $.post @_post_url(), @_post_data(), @_post_success, "json"
    jqxhr.fail @_post_fail

  _post_url: () ->
    if @data && @data.id
      "/topics/#{@data.id}"
    else
      "/topics"

  _post_data: () ->
    method = if @data && @data.id then "patch" else "post"
    _method: method
    topic:
      name: @topic_name.val().trim()
      owner: @topic_owner.val().trim()
      description: @topic_description.val().trim()

  _post_success: (data, status) =>
    @_clear_field_errors()
    @_clear_form_fields()
    @_hide_form()
    @success_callback(data)

  _post_fail: (jqXHR, status) =>
    @_clear_field_errors()
    errors = jqXHR.responseJSON && jqXHR.responseJSON.errors
    if errors && errors.name && errors.name.length > 0
      @topic_name.parents(".form-group").addClass("has-error")
      @topic_name.parent("div").addClass("has-error")
    if errors && errors.owner && errors.owner.length > 0
      @topic_owner.parents(".form-group").addClass("has-error")
      @topic_owner.parent("div").addClass("has-error")

  _clear_field_errors: () ->
    @topic_name.parents(".form-group").removeClass("has-error")
    @topic_name.parent("div").removeClass("has-error")
    @topic_owner.parents(".form-group").removeClass("has-error")
    @topic_owner.parent("div").removeClass("has-error")

  _clear_form_fields: () ->
    @topic_name.val ""
    @topic_owner.val ""
    @topic_description.val ""
