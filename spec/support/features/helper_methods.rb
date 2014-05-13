module Features
  module HelperMethods
    def given_logged_in_as(user)
      visit "/users/sign_in"
      fill_in("Correo electrónico", :with => user.email)
      fill_in("Contraseña", :with => user.password)
      click_on("Entrar")
    end

    def sees_success_message(message)
      within ".alert-success" do
        expect(page).to have_text(message)
      end
    end

    def sees_error_message(message)
      within ".alert-danger" do
        expect(page).to have_text(message)
      end
    end
  end
end
