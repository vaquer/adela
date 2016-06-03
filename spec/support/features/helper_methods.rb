module Features
  module HelperMethods
    def given_logged_in_as(user)
      visit "/usuarios/ingresa"
      fill_in("Correo electrónico", :with => user.email)
      fill_in("Contraseña", :with => user.password)
      click_on("Entrar")
    end

    def given_organization_with_catalog
      create(:inventory, organization: @user.organization)
      create(:catalog, :datasets, organization: @user.organization)
    end

    def given_organization_with_opening_plan
      create(:catalog, :datasets, organization: @user.organization)
    end

    def sees_success_message(message)
      within(".toast-success") do
        expect(page).to have_text(message)
      end
    end

    def sees_error_message(message)
      within first(".toast-error") do
        expect(page).to have_text(message)
      end
    end

    def given_organization_has_catalog_with(datasets)
      create :inventory, organization: @user.organization
      create :opening_plan, organization: @user.organization
      create :catalog, datasets: datasets, organization: @user.organization
      @user.organization.reload
    end

    def resource_checkbox
      find("input[type='checkbox']")
    end

    def set_rows
      all('table tbody tr.dataset')
    end

    def set_row
      set_rows.first
    end

    def resource_rows
      all('table tbody tr.distribution')
    end

    def resource_row
      resource_rows.first
    end
  end
end
