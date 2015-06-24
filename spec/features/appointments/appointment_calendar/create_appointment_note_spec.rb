require 'rails_helper'

feature 'Create Appointment Note', js: true do
  before :each do
    protocol      = create_and_assign_protocol_to_me
    @participant  = protocol.participants.first
    @visit_group  = @participant.appointments.first.visit_group
    @user         = create(:identity)
  end

  scenario 'User creates a Note and views the Notes list' do
    given_i_am_viewing_a_appointment
    and_begin_the_appointment
    when_i_add_a_note_to_a_appointment
    and_i_view_the_notes_list
    then_i_shoud_see_the_note
  end
  
  def given_i_am_viewing_a_appointment
    visit participant_path @participant
    bootstrap_select '#appointment_select', @visit_group.name
  end

  def and_begin_the_appointment
    find('button.start_visit').click
  end

  def when_i_add_a_note_to_a_appointment
    find('h3.appointment_header button.notes.list').click
    find('button.note.new').click
    fill_in 'note_comment', with: 'Test comment'
    click_button 'Save'
  end

  def and_i_view_the_notes_list
    find('h3.appointment_header button.notes.list').click
  end

  def then_i_shoud_see_the_note
    expect(page).to have_css('.modal-body .detail .comment', text: 'Test comment')
  end
end