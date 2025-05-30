# frozen_string_literal: true

require 'rails_helper'

class DummyCalculator
  include GlucoseMetricsCalculator
end

RSpec.describe GlucoseMetricsCalculator, type: :concern do
  let(:member) { create(:member) }
  let(:calculator) { DummyCalculator.new }

  before do
    # Clear all data to avoid interference
    GlucoseLevel.delete_all
    # Create 7 days of data: 2 below range, 3 in range, 2 above range
    [65, 68, 100, 120, 150, 200, 250].each_with_index do |value, i|
      create(:glucose_level, member: member, value: value, tested_at: i.days.ago)
    end
    # Create 24 days of data for month test: 10 below, 10 in, 10 above
    8.times { |i| create(:glucose_level, member: member, value: 60, tested_at: (i + 7).days.ago) }
    8.times { |i| create(:glucose_level, member: member, value: 120, tested_at: (i + 15).days.ago) }
    8.times { |i| create(:glucose_level, member: member, value: 250, tested_at: (i + 23).days.ago) }
  end

  describe '#average_week' do
    it 'returns the average glucose value for the last 7 days' do
      expect(calculator.average_week).to eq([65, 68, 100, 120, 150, 200, 250].sum / 7)
    end
  end

  describe '#average_month' do
    it 'returns the average glucose value for the current month' do
      # Only the last 31 records (from before) are in the month
      # for testing purposes, we're using May 2025
      expected = GlucoseLevel.where('tested_at >= ?', 31.days.ago).map(&:value)
      expect(calculator.average_month(5)).to eq(expected.sum / expected.size)
    end
  end

  describe '#time_below_range_week' do
    it 'returns the percent of time below range (<70) for the last week' do
      # 2 out of 7 values are below 70
      expect(calculator.time_below_range_week).to eq((2.0 / 7.0) * 100)
    end
  end

  describe '#time_below_range_month' do
    it 'returns the percent of time below range (<70) for the month' do
      # 10 out of 31 values are below 70
      # for testing purposes, we're using May 2025
      expect(calculator.time_below_range_month(5)).to eq((10.0 / 31.0) * 100)
    end
  end

  describe '#time_above_range_week' do
    it 'returns the percent of time above range (>180) for the last week' do
      # 2 out of 7 values are above 180
      expect(calculator.time_above_range_week).to eq((2.0 / 7.0) * 100)
    end
  end

  describe '#time_above_range_month' do
    it 'returns the percent of time above range (>180) for the month' do
      # 10 out of 30 values are above 180
      # for testing purposes, we're using May 2025
      expect(calculator.time_above_range_month(5)).to eq((10.0 / 31.0) * 100)
    end
  end
end
