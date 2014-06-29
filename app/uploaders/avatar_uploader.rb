class AvatarUploader < ImageUploader
  process convert: :png, resize_to_limit: [800, 800]

  version(:thumb)  { process convert: :png, resize_to_fill: [120, 120] }
end
