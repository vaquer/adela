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
      @mail.to.should eql([@user.email])
    end

    it 'Should be sent by adela' do
      @mail.from.should eql(["no-reply@adela.com"])
    end

    it "should have the right subject" do
      @mail.subject.should eql("Nuevo usuario en ADELA")
    end

    it "should have the right content" do
      @mail.body.raw_source.should include @password
      @mail.body.raw_source.should include "Te recomendamos ampliamente cambiar la contraseña temporal recibida"
    end
  end
end