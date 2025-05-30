module GlucoseMetricsCalculator
  def average_week
    levels = levels_from_week

    levels.sum / levels.size
  end

  def average_month(month = Time.now.month)
    levels = levels_from_month(month)

    levels.sum / levels.size
  end

  def time_below_range_week
    levels = levels_from_week 

    (time_below_range(levels).to_f / levels.count.to_f) * 100
  end

  def time_below_range_month(month = Time.now.month)
    levels = levels_from_month(month)

    (time_below_range(levels).to_f / levels.count.to_f) * 100
  end

  def time_above_range_week
    levels = levels_from_week

    (time_above_range(levels).to_f / levels.count.to_f) * 100
  end

  def time_above_range_month(month)
    levels = levels_from_month(month)

    (time_above_range(levels).to_f / levels.count.to_f) * 100
  end

  def levels_from_week
    GlucoseLevel.where('tested_at >= ?', 7.days.ago).map(&:value)
  end

  def levels_from_month(month)
    number_of_days = Time.days_in_month(month)

    GlucoseLevel.where('tested_at >= ?', number_of_days).map(&:value)
  end

  def time_below_range(levels)
    levels.count { |level| level < 70 }
  end

  def time_above_range(levels)
    levels.count { |level| level > 180 }
  end

end