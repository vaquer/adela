class HomeController < ApplicationController
  before_action :authenticate_user!, except: :index

  def index
    @logs = ActivityLog.date_sorted
  end
end
