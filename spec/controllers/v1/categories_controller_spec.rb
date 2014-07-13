require 'rails_helper'

describe V1::CategoriesController do
  describe 'GET #index' do
    let!(:categories) { create_list(:category, 4) }

    let(:json_categories) do
      categories.map { |c| c.slice(:id, :name) }
    end

    before { get :index }

    it { is_expected.to respond_with(200) }

    it 'responds with all categories' do
      expect(json['categories']).to match_array(json_categories)
    end
  end
end
