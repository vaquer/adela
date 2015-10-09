class CatalogsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_opening_plan

  def index
  end

  private

  def require_opening_plan
    return if current_organization.opening_plans.present?
    render :error
    return
  end
end
