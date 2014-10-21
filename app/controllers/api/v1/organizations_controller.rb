module Api
  module V1
    class OrganizationsController < ApplicationController
      include Rails.application.routes.url_helpers

      def catalogs
        @catalogs_urls = Organization.with_catalog.map { |org| organization_catalog_url(:slug => org.slug, :host => request.host, :format => :json)}
        render :json => @catalogs_urls, root: false
      end
    end
  end
end
