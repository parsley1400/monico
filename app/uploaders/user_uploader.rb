class UserUploader < CarrierWave::Uploader::Base
  include Cloudinary::CarrierWave
end
