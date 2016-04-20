class Organizations::DocumentsController < ApplicationController
  before_action :authenticate_user!

  def update
    if current_organization.update(organization_params)
      flash[:notice] = I18n.t('flash.notice.organization.documents.update')
    end
    redirect_to organization_documents_path
    return
  end

  private

  def organization_params
    params.require(:organization).permit(
      designation_files_attributes: [:file],
      memo_files_attributes: [:file]
    )
  end
end
