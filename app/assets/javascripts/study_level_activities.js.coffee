$ ->

  $(document).on 'click', ".otf_service_new", ->
    protocol_id = $('#protocol_id').val()
    data = protocol_id: protocol_id
    $.ajax
      type: 'GET'
      url: "/line_items/new"
      data: data

  $(document).on 'click', '.otf_notes', ->
    line_item_id = $(this).parents('.row.line_item').data('id')
    alert 'view line_item notes modal here'

  $(document).on 'click', '.otf_documents', ->
    line_item_id = $(this).parents('.row.line_item').data('id')
    alert 'view line_item documents modal here'

  $(document).on 'change', '.component_check', ->
    component_id = $(this).val()
    data = component: selected: $(this).is(':checked')
    $.ajax
      type: 'PATCH'
      url:  "/components/#{component_id}"
      data: data

  $(document).on 'click', '.otf_fulfillments', ->
    id = $(this).parents('.row.line_item').data('id')
    table = $("#fulfillments_list_#{id}")
    if table.hasClass('slide-active')
      table.removeClass('slide-active')
      table.addClass('slide-inactive')
      table.slideToggle()
    else
      activeSlide = $('.slide-active')
      if activeSlide.length != 0
        activeSlide.removeClass('slide-active')
        activeSlide.addClass('slide-inactive')
        activeSlide.slideToggle()
      table.removeClass('slide-inactive')
      table.addClass('slide-active')
      table.slideToggle()

  $(document).on 'click', '.otf_edit', ->
    line_item_id = $(this).parents('.row.line_item').data('id')
    $.ajax
      type: 'GET'
      url: "/line_items/#{line_item_id}/edit"

  $(document).on 'click', '.fulfillment_notes', ->
    fulfillment_id = $(this).parents('.row.fulfillment').data('id')
    alert 'view fulfillment notes modal here'

  $(document).on 'click', '.fulfillment_documents', ->
    fulfillment_id = $(this).parents('.row.fulfillment').data('id')
    alert 'view fulfillment documents modal here'

  $(document).on 'change', '.fulfillment_component', ->
    component_id = $(this).data('id')
    data = component: component: $(this).val()
    $.ajax
      type: 'PATCH'
      url:  "/components/#{component_id}"
      data: data

  $(document).on 'click', '.otf_fulfillment_new', ->
    line_item_id = $(this).parents('.fulfillments').data('line-item-id')
    data = line_item_id: line_item_id
    $.ajax
      type: 'GET'
      url: "/fulfillments/new"
      data: data

  $(document).on 'click', '.otf_fulfillment_edit', ->
    fulfillment_id = $(this).parents('.row.fulfillment').data('id')
    $.ajax
      type: 'GET'
      url: "/fulfillments/#{fulfillment_id}/edit"

