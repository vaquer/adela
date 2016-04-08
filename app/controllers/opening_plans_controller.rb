class OpeningPlansController < ApplicationController
  before_action :authenticate_user!, except: [:export]

  def export
    organization = Organization.find(params[:id])
    exporter = OpeningPlanExporter.new(organization)
    respond_to do |format|
      format.csv { send_data exporter.export }
    end
  end
end
