class Topics.Loader
  load_in: (container_selector) ->
    load_in_container = (item_data) ->
      item = new Topics.Item(item_data)
      item.load_in(container_selector)

    $.getJSON "/topics", (data) =>
      load_in_container(item) for item in data
