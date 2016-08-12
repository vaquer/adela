require 'spec_helper'

describe Api::V1::DatasetsController do
  describe 'GET #contact_point' do
    before(:each) do
      @dataset = create(:dataset)
    end

    it 'downloads the dataset contact point vcard' do
      get :contact_point, id: @dataset.id, locale: :es
      expect(response.body).to eq(
        "BEGIN:VCARD\nVERSION:4.0\nN:#{@dataset.contact_position};;;;\nFN:#{@dataset.contact_name}\nEMAIL;TYPE=[\"work\", \"internet\"];PREF=1:#{@dataset.mbox}\nEND:VCARD\n"
      )
    end
  end
end
