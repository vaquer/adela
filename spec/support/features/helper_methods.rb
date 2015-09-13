module Features
  module HelperMethods
    def given_logged_in_as(user)
      visit "/usuarios/ingresa"
      fill_in("Correo electrónico", :with => user.email)
      fill_in("Contraseña", :with => user.password)
      click_on("ENTRAR")
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

    def activity_log_created_with_msg(message)
      @activity = ActivityLog.last
      @activity.should_not be_nil
      @activity.description.should == message
    end
  end
end
