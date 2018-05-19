module YugiohX2
  class Artwork < ActiveRecord::Base
    belongs_to :card

    validates_presence_of :image_path, :source_url, :card_id
    validate :validate_image_exists?
    after_destroy :delete_image

    private
    def validate_image_exists
      if !File.exist?(self.image_path)
        errors.add(:image_path, "file not found")
      end
    end

    def delete_image
      if File.exist?(self.image_path)
        File.delete(self.image_path)
      end
    end
  end
end