# encoding: UTF-8

require 'spec_helper'

feature User, 'manages topics:' do
  background do
    @user = FactoryGirl.create(:user)
    given_logged_in_as(@user)
    visit organization_path(:id => @user.organization.id)
  end

  scenario "can see existing topics", :js => true do
    organization = @user.organization
    FactoryGirl.create(
      :opening_plan_with_officials,
      vision: "dataset-vision",
      name: "dataset-name",
      description: "dataset-description",
      organization: organization,
    )

    visit organization_path(:id => @user.organization.id)
    within all(".section-content").last do
      page.should have_content "dataset-vision"
      page.should have_content "dataset-name"
      page.should have_content "dataset-description"
    end
  end
end
