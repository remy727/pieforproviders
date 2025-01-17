# frozen_string_literal: true

module Illinois
  module Daily
    # Calculate earned revenue for a given service day
    class RevenueCalculator
      attr_reader :business, :child, :child_approval, :date, :total_time_in_care, :rates

      ATTENDANCE_THRESHOLD = 69.5

      def initialize(child_approval:, date:, total_time_in_care:, rates:)
        @child_approval = child_approval
        @child = child_approval.child
        @business = child.business
        @date = date
        @rates = rates
        @total_time_in_care = total_time_in_care
      end

      def call
        calculate_earned_revenue
      end

      private

      def calculate_earned_revenue
        child_approval&.special_needs_rate ? il_special_needs_revenue : il_base_revenue
      end

      def il_special_needs_revenue
        (days_attended[:part_time] * child_approval.special_needs_hourly_rate) +
          (days_attended[:full_time] * child_approval.special_needs_daily_rate)
      end

      def il_base_revenue
        (days_attended[:part_time] * part_day_rate) +
          (days_attended[:full_time] * full_day_rate)
      end

      def days_attended
        Illinois::Daily::DaysDurationCalculator.new(total_time_in_care: total_time_in_care).call
      end

      def part_day_rate
        rates.find do |rate|
          rate.rate_type == 'part_day' && rate_time_check(rate)
        end&.amount || 0
      end

      def full_day_rate
        rates.find do |rate|
          rate.rate_type == 'full_day' && rate_time_check(rate)
        end&.amount || 0
      end

      def rate_time_check(rate)
        rate.effective_on <= date && (rate.expires_on.nil? || rate.expires_on > date)
      end
    end
  end
end
