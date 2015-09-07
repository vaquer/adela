class HomeController < ApplicationController
  before_action :authenticate_user!, :except => [:index]

  layout 'home'

  def index
    @logs = ActivityLog.date_sorted
    @organizations = Organization.includes(:activity_logs).all.sort_by(&:current_datasets_count).reverse.paginate(:page => params[:page], :per_page => 5)
  end

  def maqueta
    # dummy test try the hack with real files
    if request.post?
      raise params.inspect
    end
  end
end
