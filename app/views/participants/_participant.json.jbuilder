json.(participant)
json.id participant.id
json.protocol_id participant.protocol_id
json.arm_id participant.arm_id
json.arm_name truncated_formatter(participant.arm.name) if participant.arm
json.first_middle truncated_formatter(participant.first_middle)
json.first_name truncated_formatter(participant.first_name.humanize)
json.middle_initial participant.middle_initial
json.last_name truncated_formatter(participant.last_name.humanize)
json.name truncated_formatter(participant.full_name)
json.mrn truncated_formatter(participant.mrn)
json.external_id truncated_formatter(participant.external_id)
json.status participant.status
json.date_of_birth format_date(participant.date_of_birth)
json.gender participant.gender
json.ethnicity participant.ethnicity
json.race participant.race
json.address truncated_formatter(participant.address)
json.phone participant.phone
json.details detailsFormatter(participant)
json.edit editFormatter(participant)
json.delete deleteFormatter(participant)
json.calendar calendarFormatter(participant)
json.report statsFormatter(participant)
json.chg_arm changeArmFormatter(participant)
json.recruitment_source recruitment_formatter(participant)
json.coordinators formatted_coordinators(participant.protocol.coordinators.map(&:full_name))
