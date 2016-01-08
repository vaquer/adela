#encoding: utf-8;
require "spec_helper"

describe UserMailer do
  describe '.notificate_user_account' do
    before do
      @password = "kKp0-trm"
      @user = FactoryGirl.create(:user, :email => "test@mail.com", :password => @password, :password_confirmation => @password)
      @mail = UserMailer.notificate_user_account(@user, @password)
    end

    it "should be sent to the users email" do
      expect(@mail.to).to eql([@user.email])
    end

    it 'Should be sent by adela' do
      expect(@mail.from).to eql(["no-reply@adela.com"])
    end

    it "should have the right subject" do
      expect(@mail.subject).to eql("Nuevo usuario en ADELA")
    end

    it "should have the right content" do
      expect(@mail.body.raw_source).to include @password
      expect(@mail.body.raw_source).to include "Te recomendamos ampliamente cambiar la contraseña temporal recibida"
    end
  end
end