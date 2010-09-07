# encoding: utf-8
# author: Boris Barroso
# email: boriscyber@gmail.com
class Contacto < ActiveRecord::Base
  validates_presence_of :nombre, :email
  validates_format_of :email, :with => Constants::EMAIL_REG
end
