class DistributionsController < ApplicationController
  before_action :authenticate_user!

  def edit
    @distribution = Distribution.find(params['id'])
  end

  def update
    @distribution = Distribution.find(params['id'])
    @distribution.update(distribution_params)
    redirect_to edit_dataset_path(@distribution.dataset)
    return
  end

  private

  def distribution_params
    params.require(:distribution).permit(:title, :publish_date, :download_url, :modified, :temporal, :byte_size)
  end
end
