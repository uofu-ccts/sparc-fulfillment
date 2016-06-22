$("#modal_area").html("<%= escape_javascript(render(partial: 'incomplete_all_modal', locals: { procedure_ids: @procedure_ids, note: @note})) %>")
$("#modal_place").modal 'show'

$(".selectpicker").selectpicker()

$(".modal_date_field").datetimepicker
  defaultDate: date
  ignoreReadonly: true


$(document).on 'click', "#incomplete_all_modal button.save", (e) ->
  if !$('#incomplete_all_modal .performed-by-dropdown').val() || !$('#incomplete_all_modal .reason-select').val()
    e.preventDefault()
    $('#multiple_procedures_modal_errors').addClass('alert').addClass('alert-danger').html('Please complete the required fields:')
  else
    $(this).addClass("disabled")

