module Api
  module V1
    class OrganizationsController < ApplicationController
      include Rails.application.routes.url_helpers

      def catalogs
        @catalogs_urls = Organization.with_catalog.map { |org| organization_catalog_url(:slug => org.slug, :host => request.host, :format => :json)}
        render :json => @catalogs_urls, root: false
      end

      def organizations
        @organizations = organizations_array.paginate(:page => params[:page])
        render :json => @organizations, serializer: OrganizationAPISerializer, root: false
      end

      private

      def organizations_array
        if Organization.gov_types.has_key?(params[:gov_type])
          Organization.send(params[:gov_type])
        else
          Organization.all
        end
      end
    end
  end
end
