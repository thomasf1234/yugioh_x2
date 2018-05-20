require 'RMagick'

module YugiohX2
  class Card < ActiveRecord::Base
    module Types
      MONSTER = 'Monster'
      NON_MONSTER = 'NonMonster'
      ALL = constants.collect { |const| module_eval(const.to_s) }
    end

    module Categories
      NORMAL = 'Normal'
      EFFECT = 'Effect'
      FUSION = 'Fusion'
      RITUAL = 'Ritual'
      SYNCHRO = 'Synchro'
      XYZ = 'Xyz'
      PENDULUM = 'Pendulum'
      SPELL = 'Spell'
      TRAP = 'Trap'
      ALL = constants.collect { |const| module_eval(const.to_s) }
    end

    validates_presence_of :db_name, :name, :description
    validates :category, inclusion: { in: Categories::ALL, message: "%{value} is not a valid category" }
    validates :card_type, inclusion: { in: Types::ALL, message: "%{value} is not a valid card_type" }

    has_many :artworks, dependent: :destroy
    has_many :monster_types, foreign_key: 'card_id', dependent: :destroy

    if ENV['ENV'] != 'test'
      after_initialize :readonly!
    end

    def thumbnail(artwork_index=0)
      template = Magick::Image.read("app/controllers/public/images/templates/#{category.downcase}.png").first
      artwork = Magick::Image.read(artworks[artwork_index].image_path).first.scale(209, 230)
      template.composite!(artwork, 5, 5, Magick::OverCompositeOp)   
    end
  end
end

# YugiohX2::Card.all.each do |card|
#   next if card.category == 'Pendulum'
#   card.artworks.each_with_index do |artwork, index|
#     file_path = "tmp/#{card.id}_#{index}.bmp"
#     if !File.exist?(file_path)
#       begin
#         card.thumbnail(index).write(file_path)
#       rescue => e
#         puts "Error occurred for card #{card.id}, artwork: #{artwork.id}: #{e}"
#       end
#     end
#   end
# end
