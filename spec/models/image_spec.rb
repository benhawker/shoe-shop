require 'spec_helper'

describe Image do
  describe 'validations' do
    it { should validate_presence_of(:post_id) }
    it { should validate_presence_of(:url)}
  end

  let(:image) {FactoryGirl.create(:image)}

  describe '#url_size' do 
    it "should allow for variable sizes, including 900" do
      target_url = image.url + "/convert?rotate=exif&w=900&h=900&fit=crop"
      expect(image.url_size(900)).to eq target_url
    end
  end

end
