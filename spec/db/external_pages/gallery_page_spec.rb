require 'spec_helper'

module YugiohX2Spec
  RSpec.describe YugiohX2Lib::ExternalPages::GalleryPage do
    describe 'card_type' do
      let(:gallery_page) { YugiohX2Lib::ExternalPages::MainPage.new(card_db_name).gallery_page }

      context 'Obelisk the Tormentor' do
        let(:card_db_name) { 'Obelisk_the_Tormentor' }

        it "should contain the correct urls" do
          expect(gallery_page.fetch_image_urls.count).to eq(4)
        end
      end

      context 'Dark Magician' do
        let(:card_db_name) { 'Dark_Magician' }

        it "should contain the correct urls" do
          expect(gallery_page.fetch_image_urls.count).to eq(8)
        end
      end

      context 'Red Dragon Archfiend' do
        let(:card_db_name) { 'Red_Dragon_Archfiend' }

        it "should contain the correct urls" do
          expect(gallery_page.fetch_image_urls.count).to eq(2)
        end
      end

      context 'Relinquished' do
        let(:card_db_name) { 'Relinquished' }

        it "should contain the correct urls" do
          expect(gallery_page.fetch_image_urls.count).to eq(2)
        end
      end

      context 'Hundred Eyes Dragon' do
        let(:card_db_name) { 'Hundred_Eyes_Dragon' }

        it "should contain the correct urls" do
          expect(gallery_page.fetch_image_urls.count).to eq(2)
        end
      end

      context 'The Winged Dragon of Ra' do
        let(:card_db_name) { 'The_Winged_Dragon_of_Ra' }

        it "should contain the correct urls" do
          expect(gallery_page.fetch_image_urls.count).to eq(4)
        end
      end

      context 'Blue-Eyes White Dragon' do
        let(:card_db_name) { 'Blue-Eyes_White_Dragon' }

        it "should contain the correct urls" do
          expect(gallery_page.fetch_image_urls.count).to eq(8)
        end
      end
    end
  end
end


