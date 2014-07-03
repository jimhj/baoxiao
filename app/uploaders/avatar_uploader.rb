class AvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  version :normal do
    # process resize_to_fit: [120, 120]
    # process crop: '120x120+0+0'
    process resize_and_crop: 120
  end

  version :thumb do
    # process resize_to_fit: [80, nil]
    # process crop: '80x80+0+0'
    process resize_and_crop: 80
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

  # Resize and crop square from Center
  def resize_and_crop(size)  
    manipulate! do |image|                 
      if image[:width] < image[:height]
        remove = ((image[:height] - image[:width])/2).round 
        image.shave("0x#{remove}") 
      elsif image[:width] > image[:height] 
        remove = ((image[:width] - image[:height])/2).round
        image.shave("#{remove}x0")
      end
      image.resize("#{size}x#{size}")
      image
    end
  end  
end