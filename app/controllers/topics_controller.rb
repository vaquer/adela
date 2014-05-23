class TopicsController < ApplicationController
  respond_to :html, :json

  # FIXME Should move this to the ApplicationController
  before_action :authenticate_user!

  layout 'home'

  def index
  end

  def create
    @topic = Topic.new topic_params
    @topic.sort_order = 1 # FIXME calculate sort order
    @topic.organization_id = current_organization.id
    @topic.save

    respond_with @topic
  end


  private

  def topic_params
    params.require(:topic).permit(:name, :owner, :description)
  end
end
