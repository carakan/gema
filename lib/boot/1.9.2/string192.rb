String.class_eval do
  def upcase
    UnicodeUtils.upcase(self)
  end

  def downcase
    UnicodeUtils.downcase(self)
  end
end
