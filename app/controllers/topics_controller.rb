class TopicsController < ApplicationController
  respond_to :html, :json

  # FIXME Should move this to the ApplicationController
  before_action :authenticate_user!

  layout 'home'

  def index
    respond_to do |format|
      format.html do
        # FIXME When do we show this notice?
        flash[:notice] = "Bienvenido, el primer paso es crear tu plan de apertura"
      end
      format.json { render :json => Topic.all }
    end
  end

  def create
    @topic = Topic.new topic_params
    @topic.organization_id = current_organization.id
    @topic.save

    respond_with @topic
  end


  private

  def topic_params
    params.require(:topic).permit(:name, :owner, :description)
  end
end
