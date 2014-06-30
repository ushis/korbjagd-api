class AvatarUploader < ImageUploader
  process convert: :png, resize_to_limit: [800, 800]

  version(:thumb) { process convert: :png, resize_to_fill: [44, 44] }
  version(:small) { process convert: :png, resize_to_fill: [100, 100] }
end
