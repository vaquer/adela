class HomeController < ApplicationController
  before_action :authenticate_user!, :except => [:index]

  layout 'home'

  def index
    @logs = ActivityLog.date_sorted
    @organizations = Organization.includes(:activity_logs).all.sort_by(&:current_datasets_count).reverse.paginate(:page => params[:page], :per_page => 5)
    @current_month = params[:month] || I18n.l(Date.today.at_beginning_of_month, :format => "01-%m-%Y")
    @opening_plans = OpeningPlan.by_month(@current_month.to_date)
  end
end
