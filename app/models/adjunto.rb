class Adjunto < ActiveRecord::Base
  belongs_to :adjuntable, :polymorphic => true
end
