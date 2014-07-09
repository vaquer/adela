class HomeController < ApplicationController
  before_action :authenticate_user!, :except => [:index]

  layout 'home'

  def index
    @logs = ActivityLog.date_sorted
    @organizations = Organization.paginate(:page => params[:page], :per_page => 5)
  end
end