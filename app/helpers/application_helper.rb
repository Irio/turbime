module ApplicationHelper
  def days_left project
    days = (project.expires_at.to_date - Date.today).to_i
    days > 0 ? days : 0
  end
  def percent project
    p = (100 * (rand(98) / project.goal).to_f).to_i
    if p >= 100
      100
    else
      p
    end
  end
end
