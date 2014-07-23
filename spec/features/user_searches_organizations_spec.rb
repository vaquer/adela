
require 'spec_helper'

feature User, 'searches organizations:' do
  background do
    @organization1 = FactoryGirl.create(:organization, :title => "Hacienda")
    @organization2 = FactoryGirl.create(:organization, :title => "SEP")
  end

  scenario "can search an organization by title" do
    visit root_path

    fill_in "q", :with => "haciend"
    click_on "search"

    within find("#organizations") do
      page.should have_content @organization1.title
      page.should_not have_content @organization2.title
    end
  end

  scenario "can search with an empty term" do
    visit root_path

    fill_in "q", :with => ""
    click_on "search"

    within find("#organizations") do
      page.should have_content @organization1.title
      page.should have_content @organization2.title
    end
  end
end