require 'spec_helper'

describe CatalogMailer do
  let(:catalog) { create(:catalog, :datasets) }
  let(:user) { create(:user) }
  let(:mail) { CatalogMailer.publish_email(catalog.id, user.id) }

  it 'renders the receiver email' do
    expect(mail.to).to eql([user.email])
  end

  it 'renders the subject' do
    upcase_slug = catalog.organization.slug.upcase
    epoch_time = catalog.publish_date.to_i
    expected_subject = "Folio de publicación de catálogo de datos: #{upcase_slug}-#{epoch_time}"
    expect(mail.subject).to eql(expected_subject)
  end
end
