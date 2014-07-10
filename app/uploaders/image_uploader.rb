class ImageUploader < DataUrlUploader

  def move_to_store
    true
  end

  def store_dir
    File.join('uploads', model.class.to_s.underscore.pluralize)
  end

  def cache_dir
    File.join('uploads', 'tmp')
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end
end
