class Representante < ActiveRecord::Base
  validates_presence_of :nombre, :email
  validates_format_of :email, :with => EMAIL_REG
end
