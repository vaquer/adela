class TopicsController < ApplicationController
  # FIXME Should move this to the ApplicationController
  before_action :authenticate_user!

  layout 'home'

  def index
    flash[:notice] = "Bienvenido, el primer paso es crear tu plan de apertura"
  end
end
