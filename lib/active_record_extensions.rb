ActiveRecord::Base.instance_eval do
  def convert_boolean(param)
    if ['true', 't', 1].include?(param)
      return true
    elsif ['false', 'f', 0].include?(param)
      return false
    end
    nil
  end

  def lista(label, options = {})
    options.merge(:select => "id, #{label}")
    all(options).map{ |v| [v.send(label), v.id] }
  end
end
