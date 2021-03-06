# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  include CarrierWave::RMagick

  # Choose what kind of storage to use for this uploader:
  if Rails.env.production?
    storage :fog
  end
  # storage :file

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Create different versions of your uploaded files:
  version :small do
    process :resize_to_limit => [150, 150]
  end

  version :thumb do
    process :resize_to_limit => [300, 300]
  end

  version :medium do
    process :resize_to_limit => [700, 700]
  end

  version :large do
    process :resize_to_limit => [1024, 1024]
  end

  # Add a white list of extensions which are allowed to be uploaded.
  def extension_white_list
    %w(jpg jpeg gif png)
  end

end
