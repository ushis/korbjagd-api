require 'rails_helper'

describe V1::SectorsController do
  describe 'GET #index' do
    before(:all) do
      Sector.connection.transaction { create_list(:sector, 720) }
    end

    after(:all) { Sector.delete_all }

    before { get :index, params }

    context 'without params' do
      let(:params) { nil }

      let(:sectors) { Sector.limit(360).order(:id) }

      it { is_expected.to respond_with(200) }

      it 'contains the first 360 sectors' do
        expect(json['sectors']).to match_array(json_sectors(sectors))
      end

      it 'responds with the correct page' do
        expect(json['params']['page']).to eq(1)
      end

      it 'responds with the correct total pages' do
        expect(json['params']['total_pages']).to eq(2)
      end
    end

    context 'with page 2' do
      let(:params) { {page: 2} }

      let(:sectors) { Sector.offset(360).limit(360).order(:id) }

      it { is_expected.to respond_with(200) }

      it 'contains the second 360 sectors' do
        expect(json['sectors']).to match_array(json_sectors(sectors))
      end

      it 'responds with the correct page' do
        expect(json['params']['page']).to eq(2)
      end

      it 'responds with the correct total pages' do
        expect(json['params']['total_pages']).to eq(2)
      end
    end

    context 'with page param out of range' do
      let(:params) { {page: 13} }

      it { is_expected.to respond_with(200) }

      it 'contains no sectors' do
        expect(json['sectors']).to be_empty
      end

      it 'responds with the correct page' do
        expect(json['params']['page']).to eq(13)
      end

      it 'responds with the correct total pages' do
        expect(json['params']['total_pages']).to eq(2)
      end
    end
  end

  describe 'GET #show' do
    before { get :show, {id: id} }

    context 'with invalid id' do
      let(:id) { 2549 }

      it { is_expected.to respond_with(404) }
    end

    context 'with valid id' do
      let(:id) { rand(Sector::ROWS*Sector::COLS) }

      let(:sector) { Sector.find(id) }

      it { is_expected.to respond_with(200) }

      it 'responds with the correct sector' do
        expect(json['sector']).to eq(json_sector(sector))
      end
    end
  end
end
