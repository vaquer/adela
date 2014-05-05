class InventoriesController < ApplicationController
  before_action :authenticate_user!

  layout 'home'

  def new
  end
end