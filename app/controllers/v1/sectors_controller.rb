class V1::SectorsController < V1::ApplicationController
  skip_before_action :authenticate, only: [:index, :show]

  before_action :find_sector, only: [:show]

  # GET /v1/sectors
  def index
    @sectors = policy_scope(Sector).order(:id).page(params[:page]).per(360)

    if stale?(@sectors, public: true)
      render json: @sectors, meta_key: :params, meta: index_meta_data
    end
  end

  # GET /v1/sectors/:id
  def show
    if stale?(@sector, public: true)
      render json: @sector
    end
  end

  private

  # Finds the requested sector
  def find_sector
    @sector = Sector.find_or_create_by_id(params[:id])
    authorize @sector
  rescue ActiveRecord::RecordInvalid
    not_found
  end

  # Returns the meta data for the index request
  def index_meta_data
    {
      page: @sectors.current_page,
      total_pages: @sectors.total_pages
    }
  end
end
