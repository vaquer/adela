require 'spec_helper'

describe Api::V1::OrganizationsController do
  render_views

  describe 'GET #documents' do
    let!(:organization) { create(:organization) }
    let!(:designation_file) { create(:designation_file, organization: organization) }
    let!(:memo_file) { create(:memo_file, organization: organization) }
    let!(:ministry_memo_file) { create(:ministry_memo_file, organization: organization) }

    it 'should respond HTTP 200 Ok' do
      get :documents, id: organization.slug, format: :json
      expect(response).to have_http_status(:ok)
    end

    context 'memo_files' do
      it 'should contain the memo_files array' do
        get :documents, id: organization.slug, format: :json
        json = JSON.parse(response.body)
        expect(json).to have_key('memo_files')
      end

      it 'should contain a download_url field'  do
        get :documents, id: organization.slug, format: :json
        memo_files = JSON.parse(response.body)['memo_files']
        expect(memo_files.sample).to have_key('download_url')
      end

      it 'should contain a created_at field' do
        get :documents, id: organization.slug, format: :json
        memo_files = JSON.parse(response.body)['memo_files']
        expect(memo_files.sample).to have_key('created_at')
      end

      it 'should contain a size field' do
        get :documents, id: organization.slug, format: :json
        memo_files = JSON.parse(response.body)['memo_files']
        expect(memo_files.sample).to have_key('size')
      end
    end

    context 'designation_files' do
      it 'should contain the designation_files array' do
        get :documents, id: organization.slug, format: :json
        json = JSON.parse(response.body)
        expect(json).to have_key('designation_files')
      end

      it 'should contain a download_url field'  do
        get :documents, id: organization.slug, format: :json
        designation_files = JSON.parse(response.body)['designation_files']
        expect(designation_files.sample).to have_key('download_url')
      end

      it 'should contain a created_at field' do
        get :documents, id: organization.slug, format: :json
        designation_files = JSON.parse(response.body)['designation_files']
        expect(designation_files.sample).to have_key('created_at')
      end

      it 'should contain a size field' do
        get :documents, id: organization.slug, format: :json
        designation_files = JSON.parse(response.body)['designation_files']
        expect(designation_files.sample).to have_key('size')
      end
    end

    context 'ministry_memo_files' do
      it 'should contain the ministry_memo_files array' do
        get :documents, id: organization.slug, format: :json
        json = JSON.parse(response.body)
        expect(json).to have_key('ministry_memo_files')
      end

      it 'should contain a download_url field'  do
        get :documents, id: organization.slug, format: :json
        ministry_memo_files = JSON.parse(response.body)['ministry_memo_files']
        expect(ministry_memo_files.sample).to have_key('download_url')
      end

      it 'should contain a created_at field' do
        get :documents, id: organization.slug, format: :json
        ministry_memo_files = JSON.parse(response.body)['ministry_memo_files']
        expect(ministry_memo_files.sample).to have_key('created_at')
      end

      it 'should contain a size field' do
        get :documents, id: organization.slug, format: :json
        ministry_memo_files = JSON.parse(response.body)['ministry_memo_files']
        expect(ministry_memo_files.sample).to have_key('size')
      end
    end
  end
end
