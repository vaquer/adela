# encoding: UTF-8

require 'spec_helper'

feature User, 'navigates through calendar:' do
  background do
    @organization = FactoryGirl.create(:organization, :title => "SEP")
    visit organization_path(@organization.id)
  end

  scenario "sees current month with no opening_plans" do
    within all(".section-content").last do
      expect(page).to have_text I18n.l(Date.today, :format => :month)
      expect(page).to have_text "No hay áreas o temas programados."
    end
  end

  scenario "sees previous month with opening_plans" do
    opening_plan = FactoryGirl.create(
      :opening_plan_with_officials,
      :vision => "dataset-vision",
      :name => "dataset-name",
      :description => "dataset-description",
      :publish_date => 2.month.ago,
      :organization => @organization,
    )

    visit organization_path(@organization.id)
    click_link I18n.l(2.month.ago.to_date, :format => :month_year)

    within all(".section-content").last do
      expect(page).to have_text opening_plan.name
      expect(page).to have_text opening_plan.vision
      expect(page).to have_text opening_plan.description
    end
  end

  scenario "sees next month with opening_plans" do
    opening_plan = FactoryGirl.create(
      :opening_plan_with_officials,
      :vision => "dataset-vision",
      :name => "dataset-name",
      :description => "dataset-description",
      :publish_date => 2.month.from_now,
      :organization => @organization,
    )

    visit organization_path(@organization.id)
    click_link I18n.l(2.month.from_now.to_date, :format => :month_year)

    within all(".section-content").last do
      expect(page).to have_text opening_plan.name
      expect(page).to have_text opening_plan.vision
      expect(page).to have_text opening_plan.description
    end
  end

  scenario "sees distinct years with opening_plans" do
    opening_plan1 = FactoryGirl.create(
      :opening_plan_with_officials,
      :publish_date => 1.year.from_now,
      :organization => @organization,
    )
    opening_plan2 = FactoryGirl.create(
      :opening_plan_with_officials,
      :publish_date => 2.year.from_now,
      :organization => @organization,
    )

    visit organization_path(@organization.id)

    within all(".section-content").last do
      expect(page).to have_link 1.year.from_now.strftime("%Y")
      expect(page).to have_text 2.year.from_now.strftime("%Y")
    end
  end
end
