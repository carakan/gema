# encoding: utf-8
# author: Boris Barroso
# email: boriscyber@gmail.com
class ReportBase < Prawn::Document
  attr_accessor :dataset

  def mini_ficha
    
  end

  def logo_orpan
    create_stamp("logo_orpan") do
      image "#{Rails.root}/public/images/logo-orpan.jpg", :vposition => -30, :fit => [100, 70]
    end
    stamp("logo_orpan")
  end

  def logoOrpan
    logo_orpan
  end
end
