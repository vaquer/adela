module Api
  module V1
    class OrganizationsController < ApplicationController
      include Rails.application.routes.url_helpers
      has_scope :sector
      has_scope :gov_type

      def show
        @organization = Organization.friendly.find(params[:id])
        render json: @organization, root: false
      end

      def inventory
        @organization = Organization.friendly.find(params[:id])
        respond_to do |format|
          format.json { render json: @organization.catalog, serializer: InventoriesSerializer, root: false }
        end
      end

      def catalogs
        @catalogs_urls = Organization.all.select do |organization|
          organization.catalog.present? && organization.catalog.distributions.map(&:published?).any?
        end
        render json: @catalogs_urls, root: false
      end

      def organizations
        @organizations = apply_scopes(Organization).paginate(page: params[:page])
        render :json => @organizations, serializer: OrganizationAPISerializer, root: false
      end

      def gov_types
        @gov_types = Organization.gov_types_i18n.map { |key, value| { id: key, value: value } }
        @gov_types = @gov_types.paginate(:page => params[:page])
        render :json => @gov_types, serializer: GovTypesSerializer, root: false
      end
    end
  end
end
