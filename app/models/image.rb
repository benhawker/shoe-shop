class Image < ActiveRecord::Base
  belongs_to :post, counter_cache: true
  validates_presence_of :post_id
  validates_presence_of :url

  def url_size(number=600, rotate="exif", fit="crop")
    url + "/convert?rotate=#{rotate}&w=#{number}&h=#{number}&fit=#{fit}"
  end
end
