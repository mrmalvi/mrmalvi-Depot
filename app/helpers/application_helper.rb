module ApplicationHelper
  def number_to_currency(price)
    sprintf("$%0.02f", price)
  end

  def render_if(condition, record)
    if condition
      render record
    end
  end

  def format_datetime(time)
    time.in_time_zone('Asia/Kolkata').strftime("%B %d, %Y %-I:%M %P")
  end
end
