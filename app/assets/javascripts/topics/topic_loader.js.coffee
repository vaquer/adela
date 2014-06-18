class Topics.Loader
  load_in: (container_selector) ->
    load_in_container = (item_data) ->
      item = new Topics.Item(item_data)
      item.load_in(container_selector)

    $.getJSON "/topics", (data) =>
      load_in_container(item) for item in data
      $(container_selector).sortable
        revert: false
        distance: 20
        cursor: "move"
        update: (event, ui) ->
          new_sorted_ids = $(container_selector).sortable("serialize")
          jqxhr = $.post "/topics/sort_order", new_sorted_ids
          jqxhr.done () ->
            index = 1
            $(container_selector).find(".sort-order").each () ->
              $(@).find("strong").hide().text(index).fadeIn()
              index += 1
