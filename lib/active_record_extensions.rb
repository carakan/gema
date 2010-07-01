ActiveRecord::Base.instance_eval do
  def convert_boolean(param)
    if ['true', 't', 1].include?(param)
      return true
    elsif ['false', 'f', 0].include?(param)
      return false
    end
    nil
  end
end
