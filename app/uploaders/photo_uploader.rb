class PhotoUploader < ImageUploader
  process convert: :png, resize_to_limit: [800, 800]

  version(:thumb)  { process convert: :png, resize_to_fill: [100, 100] }
  version(:small)  { process convert: :png, resize_to_fit:  [250, 250] }
  version(:medium) { process convert: :png, resize_and_pad: [600, 600] }
end
