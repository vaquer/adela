class HomeController < ApplicationController
  before_action :authenticate_user!, :except => [:index]

  layout 'home'

  def index
    if current_organization
      if current_organization.topics.any? && current_organization.inventories.any?
        redirect_to organization_path(current_organization)
      elsif current_organization.topics.any?
        redirect_to new_inventory_path
      else
        redirect_to topics_path
      end
    end
  end
end