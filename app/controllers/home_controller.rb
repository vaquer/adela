class HomeController < ApplicationController
  before_action :authenticate_user!, :except => [:index]

  layout 'home'

  def index
    if current_user
      redirect_to organization_path(current_organization)
    end
  end

end