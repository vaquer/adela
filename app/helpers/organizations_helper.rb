module OrganizationsHelper
  def options_for_gov_types_select(organization)
    options_for_select(Organization.gov_types_i18n.to_a.map {|k, v| [v, k]}, organization.gov_type)
  end

  def options_for_organization_admin(organization)
    options_for_select(User.organization(organization.id).map { |user| [user.name, user.id] }, organization_admin(organization))
  end

  def options_for_organization_liaison(organization)
    options_for_select(User.organization(organization.id).map { |user| [user.name, user.id] }, organization_liaison(organization))
  end

  private

  def organization_admin(organization)
    organization.administrator.user.try(:id) if organization.administrator
  end

  def organization_liaison(organization)
    organization.liaison.user.try(:id) if organization.liaison
  end
end
