class HqPicUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :file

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def fix_exif_rotation
    manipulate! do |img|
      img.tap(&:auto_orient)
    end
  end

  # Process files as they are uploaded:
  process resize_to_fit: [1100, 550]
  process :fix_exif_rotation

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def content_type_whitelist
    /image\//
  end
    
end