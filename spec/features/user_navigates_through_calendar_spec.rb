# encoding: UTF-8

require 'spec_helper'

feature User, 'navigates through calendar:' do
  background do
    @organization = FactoryGirl.create(:organization, :title => "SEP")
    visit organization_path(@organization.id)
  end

  scenario "sees current month with no topics" do
    within all(".section-content").last do
      expect(page).to have_text I18n.l(Date.today, :format => :month)
      expect(page).to have_text "No hay áreas o temas programados."
    end
  end

  scenario "sees previous month with topics" do
    topic = FactoryGirl.create(:published_topic, :publish_date => 2.month.ago, :organization => @organization)
    visit organization_path(@organization.id)
    click_link I18n.l(2.month.ago.to_date, :format => :month_year)

    within all(".section-content").last do
      expect(page).to have_text topic.name
      expect(page).to have_text topic.owner
      expect(page).to have_text topic.description
    end
  end

  scenario "sees next month with topics" do
    topic = FactoryGirl.create(:published_topic, :publish_date => 2.month.from_now, :organization => @organization)
    visit organization_path(@organization.id)
    click_link I18n.l(2.month.from_now.to_date, :format => :month_year)

    within all(".section-content").last do
      expect(page).to have_text topic.name
      expect(page).to have_text topic.owner
      expect(page).to have_text topic.description
    end
  end
end