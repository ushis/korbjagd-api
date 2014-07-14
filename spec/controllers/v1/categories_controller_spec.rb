require 'rails_helper'

describe V1::CategoriesController do
  describe 'GET #index' do
    let!(:categories) { create_list(:category, 4) }

    before { get :index }

    it { is_expected.to respond_with(200) }

    it 'responds with all categories' do
      expect(json['categories']).to match_array(json_categories(categories))
    end
  end
end
