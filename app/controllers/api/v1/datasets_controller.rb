class Api::V1::DatasetsController < ApplicationController
  def contact_point
    dataset = Dataset.find(params[:id])
    send_data vcard(dataset).to_s
  end

  private

  def vcard(dataset)
    vcard = VCardigan.create
    vcard.name dataset.contact_position
    vcard.fullname dataset.contact_name
    vcard.email dataset.mbox, type: %w(work internet), preferred: 1
    vcard
  end
end
