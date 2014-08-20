module ApiHelper
  def set_auth_header(token)
    request.headers['Authorization'] = "Bearer #{token}" unless token.nil?
  end

  def json
    @json ||= JSON.parse(response.body)
  end

  def json_record(record)
    yield(record).stringify_keys if record.present?
  end

  def json_categories(categories)
    categories.map { |category| json_category(category) }
  end

  def json_category(category)
    json_record(category) do |c|
      {
        id: c.id,
        name: c.name
      }
    end
  end

  def json_user(user)
    json_record(user) do |u|
      {
        id: u.id,
        username: u.username,
        avatar: u.avatar
      }
    end
  end

  def json_profile(user)
    json_record(user) do |u|
      json_user(u).merge({
        email: u.email,
        admin: u.admin,
        notifications_enabled: u.notifications_enabled,
        baskets_count: u.baskets.count,
        created_at: u.created_at.as_json,
        updated_at: u.updated_at.as_json,
      })
    end
  end

  def json_session(user)
    json_record(user) do |u|
      json_profile(u).merge({auth_token: u.auth_token})
    end
  end

  def json_avatar(avatar)
    json_record(avatar) do |a|
      {
        id: a.id,
        url: a.image.url,
        created_at: a.created_at.as_json,
        updated_at: a.updated_at.as_json
      }
    end
  end

  def json_photo(photo)
    json_record(photo) do |p|
      {
        id: p.id,
        url: p.image.url,
        user: json_user(p.user),
        created_at: p.created_at.as_json,
        updated_at: p.updated_at.as_json
      }
    end
  end

  def json_comments(comments)
    comments.map { |comment| json_comment(comment) }
  end

  def json_comment(comment)
    json_record(comment) do |c|
      {
        id: c.id,
        comment: c.comment,
        user: json_user(c.user),
        created_at: c.created_at.as_json,
        updated_at: c.updated_at.as_json
      }
    end
  end

  def json_baskets(baskets)
    baskets.map do |basket|
      json_record(basket) do |b|
        {
          id: b.id,
          latitude: b.latitude,
          longitude: b.longitude
        }
      end
    end
  end

  def json_basket(basket)
    json_record(basket) do |b|
      {
        id: b.id,
        latitude: b.latitude,
        longitude: b.longitude,
        name: b.name,
        comments_count: b.comments_count,
        created_at: b.created_at.as_json,
        updated_at: b.updated_at.as_json,
        user: json_user(b.user),
        photo: json_photo(b.photo),
        categories: json_categories(b.categories)
      }
    end
  end

  def json_token(token)
    json_record(token) do |t|
      {
        token: t
      }
    end
  end

  def json_sectors(sectors)
    sectors.map { |sector| json_sector(sector) }
  end

  def json_sector(sector)
    json_record(sector) do |s|
      {
        id: s.id,
        baskets_count: s.baskets_count,
        south_west: json_point(s.south_west),
        north_east: json_point(s.north_east),
        updated_at: s.updated_at.as_json,
        created_at: s.created_at.as_json
      }
    end
  end

  def json_point(point)
    json_record(point) do |p|
      {
        latitude: p.lat,
        longitude: p.lng
      }
    end
  end

  def base64_png
    'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAABH'\
    'NCSVQICAgIfAhkiAAAAAlwSFlzAAAN1wAADdcBQiibeAAAABl0RVh0U29mdHdhcmUAd3d3Lm'\
    'lua3NjYXBlLm9yZ5vuPBoAAAANSURBVAiZY/j//z8DAAj8Av6Fzas0AAAAAElFTkSuQmCC'
  end
end
