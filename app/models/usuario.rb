class Usuario < ActiveRecord::Base
  before_save :encriptar_password

  validates_presence_of :login, :password
  validates_format_of :login, :with => /^[a-z0-9_-]{4,16}$/i
  validates_uniqueness_of :login
  validates_confirmation_of :password

  #attr_accessor :password_confirmation

  # Metodo para buscar por login y password
  def self.find_login_password(l, p)
    u = first(:conditions => {:login => l})
    if u
      p = Digest::SHA1.hexdigest(p + u.password_salt)
      if p == u.password
        return u
      else
        return false
      end
    else
      return false
    end
  end

private
  def encriptar_password
    salt = Digest::MD5.hexdigest(rand().to_s)
    self.password_salt = salt
    sha1 = "#{password}#{salt}"
    self.password = Digest::SHA1.hexdigest(sha1)
  end

end
