# frozen_string_literal: true

# Service to calculate hours used in Nebraska by specific kids
class NebraskaHoursCalculator
  attr_reader :child, :date, :scope

  def initialize(child:, date:, scope:)
    @child = child
    @date = date
    @scope = scope
  end

  def call
    calculate_hours
  end

  def round_hourly_to_quarters(duration)
    (adjusted_duration(duration).in_minutes / 15.0).ceil * 15 / 60.0
  end

  private

  def calculate_hours
    attendances.reduce(0) do |sum, attendance|
      sum + round_hourly_to_quarters(attendance.total_time_in_care)
    end
  end

  def attendances
    attendances = child.active_child_approval(date).attendances.non_absences
    return attendances unless scope

    attendances.send(scope, date)
  end

  def adjusted_duration(duration)
    if duration <= (5.hours + 45.minutes)
      duration
    elsif duration > 10.hours && duration <= 18.hours
      duration - 10.hours
    elsif duration > 18.hours
      8.hours
    else
      0.minutes
    end
  end
end
