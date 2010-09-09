# encoding: utf-8
# author: Boris Barroso
# email: boriscyber@gmail.com
Hash.class_eval do
  # Convierte en Symbolos todas las llaves de un Hash
  # las llaves deben ser String
  def convert_keys_to_sym
    self.keys.map(&:to_sym).zip(self.values).inject({}) { |h, v| h[v.first] = v.last; h }
  end
end
