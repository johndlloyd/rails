require 'abstract_unit'

module DateAndTimeBehavior
  def test_yesterday
    assert_equal date_time_init(2005,2,21,10,10,10), date_time_init(2005,2,22,10,10,10).yesterday
    assert_equal date_time_init(2005,2,28,10,10,10), date_time_init(2005,3,2,10,10,10).yesterday.yesterday
  end

  def test_tomorrow
    assert_equal date_time_init(2005,2,23,10,10,10), date_time_init(2005,2,22,10,10,10).tomorrow
    assert_equal date_time_init(2005,3,2,10,10,10),  date_time_init(2005,2,28,10,10,10).tomorrow.tomorrow
  end

  def test_days_ago
    assert_equal date_time_init(2005,6,4,10,10,10),  date_time_init(2005,6,5,10,10,10).days_ago(1)
    assert_equal date_time_init(2005,5,31,10,10,10),   date_time_init(2005,6,5,10,10,10).days_ago(5)
  end

  def test_days_since
    assert_equal date_time_init(2005,6,6,10,10,10),  date_time_init(2005,6,5,10,10,10).days_since(1)
    assert_equal date_time_init(2005,1,1,10,10,10), date_time_init(2004,12,31,10,10,10).days_since(1)
  end

  def test_weeks_ago
    assert_equal date_time_init(2005,5,29,10,10,10),  date_time_init(2005,6,5,10,10,10).weeks_ago(1)
    assert_equal date_time_init(2005,5,1,10,10,10),   date_time_init(2005,6,5,10,10,10).weeks_ago(5)
    assert_equal date_time_init(2005,4,24,10,10,10),  date_time_init(2005,6,5,10,10,10).weeks_ago(6)
    assert_equal date_time_init(2005,2,27,10,10,10),  date_time_init(2005,6,5,10,10,10).weeks_ago(14)
    assert_equal date_time_init(2004,12,25,10,10,10), date_time_init(2005,1,1,10,10,10).weeks_ago(1)
  end

  def test_weeks_since
    assert_equal date_time_init(2005,7,14,10,10,10), date_time_init(2005,7,7,10,10,10).weeks_since(1)
    assert_equal date_time_init(2005,7,14,10,10,10), date_time_init(2005,7,7,10,10,10).weeks_since(1)
    assert_equal date_time_init(2005,7,4,10,10,10),  date_time_init(2005,6,27,10,10,10).weeks_since(1)
    assert_equal date_time_init(2005,1,4,10,10,10),  date_time_init(2004,12,28,10,10,10).weeks_since(1)
  end

  def test_months_ago
    assert_equal date_time_init(2005,5,5,10,10,10),  date_time_init(2005,6,5,10,10,10).months_ago(1)
    assert_equal date_time_init(2004,11,5,10,10,10), date_time_init(2005,6,5,10,10,10).months_ago(7)
    assert_equal date_time_init(2004,12,5,10,10,10), date_time_init(2005,6,5,10,10,10).months_ago(6)
    assert_equal date_time_init(2004,6,5,10,10,10),  date_time_init(2005,6,5,10,10,10).months_ago(12)
    assert_equal date_time_init(2003,6,5,10,10,10),  date_time_init(2005,6,5,10,10,10).months_ago(24)
  end

  def test_months_since
    assert_equal date_time_init(2005,7,5,10,10,10),   date_time_init(2005,6,5,10,10,10).months_since(1)
    assert_equal date_time_init(2006,1,5,10,10,10),   date_time_init(2005,12,5,10,10,10).months_since(1)
    assert_equal date_time_init(2005,12,5,10,10,10),  date_time_init(2005,6,5,10,10,10).months_since(6)
    assert_equal date_time_init(2006,6,5,10,10,10),   date_time_init(2005,12,5,10,10,10).months_since(6)
    assert_equal date_time_init(2006,1,5,10,10,10),   date_time_init(2005,6,5,10,10,10).months_since(7)
    assert_equal date_time_init(2006,6,5,10,10,10),   date_time_init(2005,6,5,10,10,10).months_since(12)
    assert_equal date_time_init(2007,6,5,10,10,10),   date_time_init(2005,6,5,10,10,10).months_since(24)
    assert_equal date_time_init(2005,4,30,10,10,10),  date_time_init(2005,3,31,10,10,10).months_since(1)
    assert_equal date_time_init(2005,2,28,10,10,10),  date_time_init(2005,1,29,10,10,10).months_since(1)
    assert_equal date_time_init(2005,2,28,10,10,10),  date_time_init(2005,1,30,10,10,10).months_since(1)
    assert_equal date_time_init(2005,2,28,10,10,10),  date_time_init(2005,1,31,10,10,10).months_since(1)
  end

  def test_years_ago
    assert_equal date_time_init(2004,6,5,10,10,10),  date_time_init(2005,6,5,10,10,10).years_ago(1)
    assert_equal date_time_init(1998,6,5,10,10,10),  date_time_init(2005,6,5,10,10,10).years_ago(7)
    assert_equal date_time_init(2003,2,28,10,10,10), date_time_init(2004,2,29,10,10,10).years_ago(1) # 1 year ago from leap day
  end

  def test_years_since
    assert_equal date_time_init(2006,6,5,10,10,10),  date_time_init(2005,6,5,10,10,10).years_since(1)
    assert_equal date_time_init(2012,6,5,10,10,10),  date_time_init(2005,6,5,10,10,10).years_since(7)
    assert_equal date_time_init(2005,2,28,10,10,10), date_time_init(2004,2,29,10,10,10).years_since(1) # 1 year since leap day
    assert_equal date_time_init(2182,6,5,10,10,10),  date_time_init(2005,6,5,10,10,10).years_since(177)
  end

  def test_beginning_of_month
    assert_equal date_time_init(2005,2,1,0,0,0), date_time_init(2005,2,22,10,10,10).beginning_of_month
  end

  def test_beginning_of_quarter
    assert_equal date_time_init(2005,1,1,0,0,0),  date_time_init(2005,2,15,10,10,10).beginning_of_quarter
    assert_equal date_time_init(2005,1,1,0,0,0),  date_time_init(2005,1,1,0,0,0).beginning_of_quarter
    assert_equal date_time_init(2005,10,1,0,0,0), date_time_init(2005,12,31,10,10,10).beginning_of_quarter
    assert_equal date_time_init(2005,4,1,0,0,0),  date_time_init(2005,6,30,23,59,59).beginning_of_quarter
  end

  def test_end_of_quarter
    assert_equal date_time_init(2007,3,31,23,59,59,Rational(999999999, 1000)), date_time_init(2007,2,15,10,10,10).end_of_quarter
    assert_equal date_time_init(2007,3,31,23,59,59,Rational(999999999, 1000)), date_time_init(2007,3,31,0,0,0).end_of_quarter
    assert_equal date_time_init(2007,12,31,23,59,59,Rational(999999999, 1000)), date_time_init(2007,12,21,10,10,10).end_of_quarter
    assert_equal date_time_init(2007,6,30,23,59,59,Rational(999999999, 1000)), date_time_init(2007,4,1,0,0,0).end_of_quarter
    assert_equal date_time_init(2008,6,30,23,59,59,Rational(999999999, 1000)), date_time_init(2008,5,31,0,0,0).end_of_quarter
  end

  def test_beginning_of_year
    assert_equal date_time_init(2005,1,1,0,0,0), date_time_init(2005,2,22,10,10,10).beginning_of_year
  end

  def test_next_week
    assert_equal date_time_init(2005,2,28,0,0,0),  date_time_init(2005,2,22,15,15,10).next_week
    assert_equal date_time_init(2005,3,4,0,0,0),   date_time_init(2005,2,22,15,15,10).next_week(:friday)
    assert_equal date_time_init(2006,10,30,0,0,0), date_time_init(2006,10,23,0,0,0).next_week
    assert_equal date_time_init(2006,11,1,0,0,0),  date_time_init(2006,10,23,0,0,0).next_week(:wednesday)
  end

  def test_next_week_with_default_beginning_of_week_set
    with_bw_default(:tuesday) do
      assert_equal Time.local(2012, 3, 28), Time.local(2012, 3, 21).next_week(:wednesday)
      assert_equal Time.local(2012, 3, 31), Time.local(2012, 3, 21).next_week(:saturday)
      assert_equal Time.local(2012, 3, 27), Time.local(2012, 3, 21).next_week(:tuesday)
      assert_equal Time.local(2012, 4, 02), Time.local(2012, 3, 21).next_week(:monday)
    end
  end

  def test_next_month_on_31st
    assert_equal date_time_init(2005,9,30,15,15,10), date_time_init(2005,8,31,15,15,10).next_month
  end

  def test_next_quarter_on_31st
    assert_equal date_time_init(2005,11,30,15,15,10), date_time_init(2005,8,31,15,15,10).next_quarter
  end

  def test_next_year
    assert_equal date_time_init(2006,6,5,10,10,10), date_time_init(2005,6,5,10,10,10).next_year
  end

  def test_prev_week
    assert_equal date_time_init(2005,2,21,0,0,0),  date_time_init(2005,3,1,15,15,10).prev_week
    assert_equal date_time_init(2005,2,22,0,0,0),  date_time_init(2005,3,1,15,15,10).prev_week(:tuesday)
    assert_equal date_time_init(2005,2,25,0,0,0),  date_time_init(2005,3,1,15,15,10).prev_week(:friday)
    assert_equal date_time_init(2006,10,30,0,0,0), date_time_init(2006,11,6,0,0,0).prev_week
    assert_equal date_time_init(2006,11,15,0,0,0), date_time_init(2006,11,23,0,0,0).prev_week(:wednesday)
  end

  def test_prev_week_with_default_beginning_of_week
    with_bw_default(:tuesday) do
      assert_equal Time.local(2012, 3, 14), Time.local(2012, 3, 21).prev_week(:wednesday)
      assert_equal Time.local(2012, 3, 17), Time.local(2012, 3, 21).prev_week(:saturday)
      assert_equal Time.local(2012, 3, 13), Time.local(2012, 3, 21).prev_week(:tuesday)
      assert_equal Time.local(2012, 3, 19), Time.local(2012, 3, 21).prev_week(:monday)
    end
  end

  def test_prev_month_on_31st
    assert_equal date_time_init(2004,2,29,10,10,10), date_time_init(2004,3,31,10,10,10).prev_month
  end

  def test_prev_quarter_on_31st
    assert_equal date_time_init(2004,2,29,10,10,10), date_time_init(2004,5,31,10,10,10).prev_quarter
  end

  def test_prev_year
    assert_equal date_time_init(2004,6,5,10,10,10),  date_time_init(2005,6,5,10,10,10).prev_year
  end

  def test_days_to_week_start
    assert_equal 0, date_time_init(2011,11,01,0,0,0).days_to_week_start(:tuesday)
    assert_equal 1, date_time_init(2011,11,02,0,0,0).days_to_week_start(:tuesday)
    assert_equal 2, date_time_init(2011,11,03,0,0,0).days_to_week_start(:tuesday)
    assert_equal 3, date_time_init(2011,11,04,0,0,0).days_to_week_start(:tuesday)
    assert_equal 4, date_time_init(2011,11,05,0,0,0).days_to_week_start(:tuesday)
    assert_equal 5, date_time_init(2011,11,06,0,0,0).days_to_week_start(:tuesday)
    assert_equal 6, date_time_init(2011,11,07,0,0,0).days_to_week_start(:tuesday)

    assert_equal 3, date_time_init(2011,11,03,0,0,0).days_to_week_start(:monday)
    assert_equal 3, date_time_init(2011,11,04,0,0,0).days_to_week_start(:tuesday)
    assert_equal 3, date_time_init(2011,11,05,0,0,0).days_to_week_start(:wednesday)
    assert_equal 3, date_time_init(2011,11,06,0,0,0).days_to_week_start(:thursday)
    assert_equal 3, date_time_init(2011,11,07,0,0,0).days_to_week_start(:friday)
    assert_equal 3, date_time_init(2011,11,8,0,0,0).days_to_week_start(:saturday)
    assert_equal 3, date_time_init(2011,11,9,0,0,0).days_to_week_start(:sunday)
  end

  def test_days_to_week_start_with_default_set
    with_bw_default(:friday) do
      assert_equal 6, Time.local(2012,03,8,0,0,0).days_to_week_start
      assert_equal 5, Time.local(2012,03,7,0,0,0).days_to_week_start
      assert_equal 4, Time.local(2012,03,6,0,0,0).days_to_week_start
      assert_equal 3, Time.local(2012,03,5,0,0,0).days_to_week_start
      assert_equal 2, Time.local(2012,03,4,0,0,0).days_to_week_start
      assert_equal 1, Time.local(2012,03,3,0,0,0).days_to_week_start
      assert_equal 0, Time.local(2012,03,2,0,0,0).days_to_week_start
    end
  end

  def test_beginning_of_week
    assert_equal date_time_init(2005,1,31,0,0,0),  date_time_init(2005,2,4,10,10,10).beginning_of_week
    assert_equal date_time_init(2005,11,28,0,0,0), date_time_init(2005,11,28,0,0,0).beginning_of_week #monday
    assert_equal date_time_init(2005,11,28,0,0,0), date_time_init(2005,11,29,0,0,0).beginning_of_week #tuesday
    assert_equal date_time_init(2005,11,28,0,0,0), date_time_init(2005,11,30,0,0,0).beginning_of_week #wednesday
    assert_equal date_time_init(2005,11,28,0,0,0), date_time_init(2005,12,01,0,0,0).beginning_of_week #thursday
    assert_equal date_time_init(2005,11,28,0,0,0), date_time_init(2005,12,02,0,0,0).beginning_of_week #friday
    assert_equal date_time_init(2005,11,28,0,0,0), date_time_init(2005,12,03,0,0,0).beginning_of_week #saturday
    assert_equal date_time_init(2005,11,28,0,0,0), date_time_init(2005,12,04,0,0,0).beginning_of_week #sunday
  end

  def test_end_of_week
    assert_equal date_time_init(2008,1,6,23,59,59,Rational(999999999, 1000)), date_time_init(2007,12,31,10,10,10).end_of_week
    assert_equal date_time_init(2007,9,2,23,59,59,Rational(999999999, 1000)), date_time_init(2007,8,27,0,0,0).end_of_week #monday
    assert_equal date_time_init(2007,9,2,23,59,59,Rational(999999999, 1000)), date_time_init(2007,8,28,0,0,0).end_of_week #tuesday
    assert_equal date_time_init(2007,9,2,23,59,59,Rational(999999999, 1000)), date_time_init(2007,8,29,0,0,0).end_of_week #wednesday
    assert_equal date_time_init(2007,9,2,23,59,59,Rational(999999999, 1000)), date_time_init(2007,8,30,0,0,0).end_of_week #thursday
    assert_equal date_time_init(2007,9,2,23,59,59,Rational(999999999, 1000)), date_time_init(2007,8,31,0,0,0).end_of_week #friday
    assert_equal date_time_init(2007,9,2,23,59,59,Rational(999999999, 1000)), date_time_init(2007,9,01,0,0,0).end_of_week #saturday
    assert_equal date_time_init(2007,9,2,23,59,59,Rational(999999999, 1000)), date_time_init(2007,9,02,0,0,0).end_of_week #sunday
  end

  def test_end_of_month
    assert_equal date_time_init(2005,3,31,23,59,59,Rational(999999999, 1000)), date_time_init(2005,3,20,10,10,10).end_of_month
    assert_equal date_time_init(2005,2,28,23,59,59,Rational(999999999, 1000)), date_time_init(2005,2,20,10,10,10).end_of_month
    assert_equal date_time_init(2005,4,30,23,59,59,Rational(999999999, 1000)), date_time_init(2005,4,20,10,10,10).end_of_month
  end

  def test_end_of_year
    assert_equal date_time_init(2007,12,31,23,59,59,Rational(999999999, 1000)), date_time_init(2007,2,22,10,10,10).end_of_year
    assert_equal date_time_init(2007,12,31,23,59,59,Rational(999999999, 1000)), date_time_init(2007,12,31,10,10,10).end_of_year
  end

  def test_monday_with_default_beginning_of_week_set
    with_bw_default(:saturday) do
      assert_equal date_time_init(2012,9,17,0,0,0), date_time_init(2012,9,18,0,0,0).monday
    end
  end

  def test_sunday_with_default_beginning_of_week_set
    with_bw_default(:wednesday) do
      assert_equal date_time_init(2012,9,23,23,59,59, Rational(999999999, 1000)), date_time_init(2012,9,19,0,0,0).sunday
    end
  end

  def with_bw_default(bw = :monday)
    old_bw = Date.beginning_of_week
    Date.beginning_of_week = bw
    yield
  ensure
    Date.beginning_of_week = old_bw
  end
end
