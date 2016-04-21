class Api::V1::DatasetsController < ApplicationController
  def contact_point
    dataset = Dataset.find(params[:id])
    send_data vcard(dataset).to_s
  end

  private

  def vcard(dataset)
    vcard = VCardigan.create
    vcard.fullname dataset.contact_position
    vcard.email dataset.mbox, type: ['work', 'internet'], preferred: 1
    vcard
  end
end
