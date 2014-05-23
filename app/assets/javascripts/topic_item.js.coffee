class window.TopicItem
  template: JST["topics/item"]

  constructor: (topic, container) ->
    @item = $ @template(topic: topic)
    @item.hide()
    container.append(@item)
    @item.fadeIn()
