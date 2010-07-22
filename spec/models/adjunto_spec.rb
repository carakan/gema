require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Adjunto do
  before(:each) do

  end

  it 'Debe crear una instancia' do
    imagen = File.join(Rails.root, 'public/images/logo-orpan.jpg')
    img = ActionController::TestUploadedFile.new(imagen, 'image/png')
    Adjunto.create!(:archivo => img)
  end
end
