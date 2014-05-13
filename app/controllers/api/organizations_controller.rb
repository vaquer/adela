module Api
  class OrganizationsController < ApplicationController
    include Rails.application.routes.url_helpers

    def catalogs
      @catalogs_urls = Organization.with_catalog.map { |org| organization_catalog_url(:slug => org.slug, :host => request.host, :format => :json)}
      render :json => @catalogs_urls
    end
  end
end