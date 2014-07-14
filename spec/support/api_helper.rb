module ApiHelper
  def set_auth_header(token)
    request.headers['Authorization'] = "Bearer #{token}"
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

  def json_profile(user)
    json_record(user) do |u|
      {
        id: u.id,
        username: u.username,
        email: u.email,
        admin: u.admin,
        notifications_enabled: u.notifications_enabled,
        baskets_count: u.baskets.count,
        created_at: u.created_at.as_json,
        updated_at: u.created_at.as_json,
        avatar: json_avatar(u.avatar)
      }
    end
  end

  def json_avatar(avatar)
    json_record(avatar) do |a|
      {
        url: a.url,
        created_at: a.created_at.as_json,
        updated_at: a.updated_at.as_json
      }
    end
  end
end
