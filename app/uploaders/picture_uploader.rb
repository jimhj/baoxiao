class PictureUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  version :normal do
    process resize_to_limit: [500, nil]
  end

  version :small do
    process resize_to_limit: [280, nil]
  end

  version :thumb do
    resize_to_fill(120, 90)
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

  # private
  
  # def crop(geometry)
  #   manipulate! do |image|      
  #     if image[:height] > 90
  #       y = (image[:height] - 90) / 2
  #       geometry = "120x90+0+#{y}"
  #     end
  #     image.crop geometry
  #     image
  #   end    
  # end  
end