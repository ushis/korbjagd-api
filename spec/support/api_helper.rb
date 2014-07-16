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
        created_at: p.created_at.as_json,
        updated_at: p.updated_at.as_json
      }
    end
  end

  def base64_png
    'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAABH'\
    'NCSVQICAgIfAhkiAAAAAlwSFlzAAAN1wAADdcBQiibeAAAABl0RVh0U29mdHdhcmUAd3d3Lm'\
    'lua3NjYXBlLm9yZ5vuPBoAAAANSURBVAiZY/j//z8DAAj8Av6Fzas0AAAAAElFTkSuQmCC'
  end
end
