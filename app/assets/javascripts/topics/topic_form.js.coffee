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
    @topic_publish_date =  template.find("#topic_publish_date")
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

    @topic_publish_date.datepicker($.datepicker.regional["es"])

    @form.submit @_handle_form_submit

  _fill_in_data: () ->
    if @data
      @topic_name.val @data.name
      @topic_publish_date.val @data.formatted_publish_date
      @topic_owner.val @data.owner
      @topic_description.val @data.description

  _hide_form: () ->
    @form_container.hide()
    @show_form_button.fadeIn() if @show_form_button

  _show_form: () ->
    @show_form_button.hide() if @show_form_button
    @form_container.fadeIn()

  _load_topic_list: (data) ->
    $.pjax({
      url: "/organizations/" + data.organization_id,
      data: { month: data.formatted_publish_date },
      container: '[data-pjax-container]'
    })

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
      publish_date: @topic_publish_date.val().trim()
      owner: @topic_owner.val().trim()
      description: @topic_description.val().trim()

  _post_success: (data, status) =>
    @_clear_field_errors()
    @_clear_form_fields()
    @_hide_form()
    @_load_topic_list(data)

  _post_fail: (jqXHR, status) =>
    @_clear_field_errors()
    errors = jqXHR.responseJSON && jqXHR.responseJSON.errors
    if errors && errors.name && errors.name.length > 0
      @topic_name.parents(".form-group").addClass("has-error")
      @topic_name.parent("div").addClass("has-error")
    if errors && errors.owner && errors.owner.length > 0
      @topic_owner.parents(".form-group").addClass("has-error")
      @topic_owner.parent("div").addClass("has-error")
    if errors && errors.publish_date && errors.publish_date.length > 0
      @topic_publish_date.parents(".form-group").addClass("has-error")
      @topic_publish_date.parent("div").addClass("has-error")

  _clear_field_errors: () ->
    @topic_name.parents(".form-group").removeClass("has-error")
    @topic_name.parent("div").removeClass("has-error")
    @topic_owner.parents(".form-group").removeClass("has-error")
    @topic_owner.parent("div").removeClass("has-error")
    @topic_publish_date.parents(".form-group").removeClass("has-error")
    @topic_publish_date.parent("div").removeClass("has-error")

  _clear_form_fields: () ->
    @topic_name.val ""
    @topic_publish_date.val ""
    @topic_owner.val ""
    @topic_description.val ""

