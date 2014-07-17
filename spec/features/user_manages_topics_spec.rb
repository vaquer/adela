# encoding: UTF-8

require 'spec_helper'

feature User, 'manages topics:' do
  background do
    @user = FactoryGirl.create(:user)
    given_logged_in_as(@user)
    visit organization_path(:id => @user.organization.id)
  end

  scenario "can see a button and a message to add first topic" do
    page.should have_button("Agregar nueva área o tema")
  end

  scenario "can add a new topic", :js => true do
    click_button "Agregar nueva área o tema"
    fill_in "Área o tema", :with => "El nombre del tema"
    fill_in "Fecha de apertura", :with => "#{I18n.l(2.months.from_now.to_date)}"
    fill_in "Responsable", :with => "Fulanito Perez"
    fill_in "Posible proyecto", :with => "Descripción de actividades"
    click_button "Guardar"

    within all(".section-content").last do
      page.should have_content "El nombre del tema"
      page.should have_content "Fulanito Perez"
      page.should have_content "Descripción de actividades"
      page.should have_content "#{I18n.l(2.months.from_now.to_date, :format => :month)}"
    end
  end

  scenario "can see existing topics", :js => true do
    organization = @user.organization
    3.times do |i|
      organization.topics.create!(
        :name => "Topic #{i}", :owner => "Owner #{i}",
        :description => "Description #{i}",
        :publish_date => i.days.from_now
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

  scenario "can edit an existing topic", :js => true do
    pending # WIP
    organization = @user.organization
    topic = organization.topics.create!(:name => "A topic",
                                        :owner => "By somebody",
                                        :publish_date => DateTime.now,
                                        :description => "With description")

    visit organization_path(:id => @user.organization.id)

    within "#topic-#{topic.id}" do
      click_link "edit-topic-#{topic.id}-link"
      fill_in "Área o tema", :with => "Edited topic"
      fill_in "Fecha de apertura", :with => "#{I18n.l(Date.tomorrow)}"
      fill_in "Responsable", :with => "Edited owner"
      fill_in "Posible proyecto", :with => "Edited description"
      click_button "Guardar"
    end

    visit organization_path(:id => @user.organization.id)
    page.should have_content "Edited topic"
    page.should have_content "Edited owner"
    page.should have_content "Edited description"
    page.should have_content "#{I18n.l(Date.tomorrow, :format => :short)}"

    page.should_not have_content "A topic"
    page.should_not have_content "By somebody"
    page.should_not have_content "With description"
  end

  scenario "can delete an existing topic", :js => true do
    organization = @user.organization
    topic = organization.topics.create!(:name => "A topic",
                                        :owner => "By somebody",
                                        :publish_date => DateTime.now,
                                        :description => "With description")

    visit organization_path(:id => @user.organization.id)

    within "#topic-#{topic.id}" do
      click_link "delete-topic-#{topic.id}-link"
      page.driver.browser.switch_to.alert.accept
    end

    visit organization_path(:id => @user.organization.id)
    page.should_not have_content "A topic"
    page.should_not have_content "By somebody"
    page.should_not have_content "With description"

    page.should have_button("Agregar nueva área o tema")
  end

  scenario "sees brief topic description", :js => true do
    organization = @user.organization
    topic = organization.topics.create!(:name => "A topic",
                                        :publish_date => DateTime.now,
                                        :owner => "By somebody",
                                        :description => "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam sed neque in magna dignissim lobortis eu tincidunt leo. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Mauris accumsan interdum nisi, ac interdum dui egestas ut. In sagittis, lorem ut dapibus sollicitudin, tellus enim ultrices nunc, eget cursus mi felis at felis. Proin in eros non magna vestibulum aliquam a eget tellus. Phasellus porta nulla ut sapien dignissim vehicula. Ut venenatis risus non eros accumsan tempus. Duis mollis lorem ut adipiscing suscipit. Donec egestas, erat nec sagittis semper, lorem lectus interdum lorem, ut feugiat ante justo eu lectus. Curabitur quis lacinia magna. Vestibulum sit amet interdum mauris.")

    visit organization_path(:id => @user.organization.id)

    page.should have_link "Ver más"
    page.should_not have_content "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam sed neque in magna dignissim lobortis eu tincidunt leo. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Mauris accumsan interdum nisi, ac interdum dui egestas ut. In sagittis, lorem ut dapibus sollicitudin, tellus enim ultrices nunc, eget cursus mi felis at felis. Proin in eros non magna vestibulum aliquam a eget tellus. Phasellus porta nulla ut sapien dignissim vehicula. Ut venenatis risus non eros accumsan tempus. Duis mollis lorem ut adipiscing suscipit. Donec egestas, erat nec sagittis semper, lorem lectus interdum lorem, ut feugiat ante justo eu lectus. Curabitur quis lacinia magna. Vestibulum sit amet interdum mauris."

    within "#topic-#{topic.id}" do
      click_link "Ver más"
    end

    page.should have_content "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam sed neque in magna dignissim lobortis eu tincidunt leo. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Mauris accumsan interdum nisi, ac interdum dui egestas ut. In sagittis, lorem ut dapibus sollicitudin, tellus enim ultrices nunc, eget cursus mi felis at felis. Proin in eros non magna vestibulum aliquam a eget tellus. Phasellus porta nulla ut sapien dignissim vehicula. Ut venenatis risus non eros accumsan tempus. Duis mollis lorem ut adipiscing suscipit. Donec egestas, erat nec sagittis semper, lorem lectus interdum lorem, ut feugiat ante justo eu lectus. Curabitur quis lacinia magna. Vestibulum sit amet interdum mauris."
  end
end
