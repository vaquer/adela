module Admin
  module UsersHelper
    def options_for_organizations_select
      current_organization = @user.organization.try(:id)
      options_for_select(organizations_options, current_organization)
    end

    def organizations_options
      Organization.all.collect { |org| [org.title, org.id] }
    end

    def user_role_description(user)
      user.has_role?(:admin) ? 'Administrador' : 'Funcionario'
    end
  end
end
