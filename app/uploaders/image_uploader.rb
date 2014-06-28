class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  before :cache, :reset_filename

  def move_to_cache
    true
  end

  def move_to_store
    true
  end

  def store_dir
    File.join('uploads',
              model.class.to_s.underscore.pluralize,
              (version_name || 'original').to_s,
              full_filename[0],
              full_filename[1])
  end

  def cache_dir
    File.join('uploads', 'tmp')
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  def full_filename(_=nil)
    model.filename
  end

  def reset_filename(_=nil)
    model.filename = "#{SecureRandom.uuid}.png"
  end
end
