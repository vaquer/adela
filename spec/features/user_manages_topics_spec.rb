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
    3.times do |i|
      organization.topics.create!(
        :name => "Topic #{i}", :owner => "Owner #{i}",
        :description => "Description #{i}",
        :publish_date => DateTime.now
      )
    end

    visit organization_path(:id => @user.organization.id)
    within all(".section-content").last do
      page.should have_content "Topic 0"
      page.should have_content "Owner 0"
      page.should have_content "Description 0"
      page.should have_content "Topic 1"
      page.should have_content "Owner 1"
      page.should have_content "Description 1"
      page.should have_content "Topic 2"
      page.should have_content "Owner 2"
      page.should have_content "Description 2"
    end
  end
end
