$("#modal_area").html("<%= escape_javascript(render(:partial =>'/service_calendar/study_schedule/edit_visit_form', locals: {protocol: @protocol, visit_group: @visit_group})) %>");
$(".selectpicker").selectpicker()
$("#modal_place").modal 'show'