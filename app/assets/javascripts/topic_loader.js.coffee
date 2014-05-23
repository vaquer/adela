class window.TopicLoader
  load_in: (container_selector) ->
    container = $ container_selector

    $.getJSON "/topics", (data) ->
      new TopicItem(item, container) for item in data
