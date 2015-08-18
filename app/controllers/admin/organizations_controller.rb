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
      params.require(:organization).permit(:title, :description, :logo_url, :gov_type)
    end
  end
end
