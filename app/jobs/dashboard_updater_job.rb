# frozen_string_literal: true

# Job to update Dashboard Cases
class DashboardUpdaterJob < ApplicationJob
  def perform(attendance:)
    DashboardUpdater.new(attendance: attendance).call
  end
end
