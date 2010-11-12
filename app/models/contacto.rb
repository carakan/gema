# encoding: utf-8
# author: Boris Barroso
# email: boriscyber@gmail.com
class Contacto < ActiveRecord::Base
  belongs_to :representante
  validates_presence_of :nombre
  validates_format_of :email, :with => Constants::EMAIL_REG, :unless => lambda { |c| c.email.blank? }
end
