class AvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  version :normal do
    process resize_to_fit: [120, nil]
    process crop: '120x120+0+0'
  end

  version :thumb do
    process resize_to_fit: [80, nil]
    process crop: '80x80+0+0'
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  def filename 
    if original_filename 
      @name ||= Digest::MD5.hexdigest(File.dirname(current_path))
      "#{@name}.#{file.extension}"
    end
  end

  def default_url
    ActionController::Base.helpers.asset_path([version_name, "avatar.png"].compact.join('_'))
  end

  private
  
  def crop(geometry)
    manipulate! do |img|      
      img.crop(geometry)
      img
    end    
  end    
end