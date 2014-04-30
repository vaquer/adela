class UsersController < ApplicationController
  before_action :authenticate_user!

  layout 'home'

  def show
  end
end