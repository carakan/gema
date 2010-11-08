# encoding: utf-8
# author: Boris Barroso
# email: boriscyber@gmail.com
class UsuarioSession
  attr_accessor :session

  def self.current_user=(usuario)
    @session = usuario
  end

  def self.current_user
    @session
  end
end
