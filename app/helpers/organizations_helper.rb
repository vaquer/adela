module OrganizationsHelper
  def options_for_gov_types_select
    options_for_select(Organization.gov_types_i18n.to_a.map {|k, v| [v, k]}, @organization.gov_type)
  end
end
