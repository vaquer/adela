class CatalogMailer < ActionMailer::Base
  add_template_helper(ApplicationHelper)
  add_template_helper(CatalogsHelper)
  add_template_helper(DatasetsHelper)

  def publish_email(catalog_id, user_id)
    @catalog = Catalog.find(catalog_id)
    @user = User.find(user_id)
    mail(to: @user.email, from: MAILER_FROM, subject: publish_email_subject(@catalog))
  end

  private

  def publish_email_subject(catalog)
    upcase_slug = @catalog.organization.slug.upcase
    epoch_time = @catalog.publish_date.to_i
    "Folio de publicación de catálogo de datos: #{upcase_slug}-#{epoch_time}"
  end
end
