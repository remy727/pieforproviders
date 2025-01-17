# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Commands::Attendance::Delete, type: :service do
  let(:child) { create(:necc_child) }
  let(:attendance) do
    create(:attendance,
           child_approval: child.child_approvals.first,
           check_in: Time.current.in_time_zone(child.timezone).prev_occurring(:monday))
  end
  let(:service_day) { attendance.service_day }

  describe '#initialize' do
    it 'initializes with required info' do
      expect do
        described_class.new(attendance: attendance)
      end.to not_raise_error
    end

    it 'throws an argument error when missing required info' do
      expect do
        described_class.new
      end.to raise_error(ArgumentError)
    end
  end

  describe '#delete' do
    it 'deletes the attendance and keeps the service_day if it has other attendances' do
      second_attendance = create(:attendance,
                                 check_in: attendance.check_in + 6.hours,
                                 service_day: service_day,
                                 child_approval: child.child_approvals.first)
      expect do
        described_class.new(attendance: attendance).delete
      end
        .to change(Attendance, :count).from(2).to(1)
        .and not_change(ServiceDay, :count)

      service_day.reload

      expect(ServiceDay.all.count).to eq(1)
      expect(service_day.attendances).not_to include(attendance)

      expect(service_day.total_time_in_care).to eq(second_attendance.time_in_care)
    end

    it 'deletes the attendance and deletes the service_day if it has no other attendances' do
      service_day.schedule.destroy!
      service_day.reload
      expect do
        described_class.new(attendance: attendance).delete
      end
        .to change(Attendance, :count).from(1).to(0)
        .and change(ServiceDay, :count).from(1).to(0)
    end

    it 'deletes the attendance, changes service_day to an absence if it has a schedule but no other absences' do
      attendance.reload
      service_day.reload
      expect do
        described_class.new(attendance: attendance).delete
      end
        .to change(Attendance, :count).from(1).to(0)
        .and not_change(ServiceDay, :count)

      service_day.reload
      expect(ServiceDay.all.count).to eq(1)
      expect(service_day.attendances).not_to include(attendance)
      expect(service_day.absence_type).to eq('absence_on_scheduled_day')
      expect(service_day.total_time_in_care).to eq(8.hours)
    end
  end
end
