class Api::V1::SectorsController < ApplicationController
  def index
    @sectors = Sector.all.paginate(page: params[:page])
    render json: @sectors, serializer: SectorsSerializer, root: false
  end
end
