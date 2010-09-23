Sctring.class_eval do
  alias_method :old_upcase, :upcase
  def upcase
    self.gsub( /\303[\240-\277]/ ) do |match|
      match[0].chr + (match[1] - 040).chr
    end.old_upcase
  end
  
  alias_method :old_downcase, :downcase
  def downcase
    self.gsub( /\303[\200-\237]/ ) do |match|
      match[0].chr + (match[1] + 040).chr
    end.old_downcase
  end
end
