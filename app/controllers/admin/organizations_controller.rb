module Admin
  class OrganizationsController < Admin::BaseController
    load_and_authorize_resource

    def index
      @organizations = Organization.includes(:users).title_sorted.paginate(page: params[:page])
    end

    def new
      @organization = Organization.new
    end

    def create
      if Organization.create(organization_params)
        flash[:notice] = I18n.t('flash.notice.organization.create')
      else
        flash[:alert] = I18n.t('flash.alert.organization.create')
      end
      redirect_to admin_organizations_path
    end

    def edit
      @organization = Organization.friendly.find(params[:id])
      @organization.build_administrator unless @organization.administrator
      @organization.build_liaison unless @organization.liaison
    end

    def update
      organization = Organization.find(params[:id])
      if organization.update(organization_params)
        flash[:notice] = I18n.t('flash.notice.organization.update')
      else
        flash[:alert] = I18n.t('flash.alert.organization.update')
      end
      redirect_to admin_organizations_path
    end

    private

    def organization_params
      params.require(:organization).permit(
        :title,
        :description,
        :logo_url,
        :gov_type,
        administrator_attributes: [:user_id],
        liaison_attributes: [:user_id],
        organization_sectors_attributes: [:id, :sector_id, :_destroy])
    end
  end
end
