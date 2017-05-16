module YugiohX2
  class Artwork < ActiveRecord::Base
    belongs_to :card

    validates_presence_of :image_path
  end
end