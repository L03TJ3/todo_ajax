require 'rails_helper'

feature 'Manage todos on the list', js: true do

  def create_todo(title)
    #point your browser towards the todo path
    visit root_path
    #enter description in the textfield
    fill_in "todo_title", with: title
    # press enter (submit the form)
    page.execute_script("$('form#new_todo').submit()")
  end

  def create_multiple()
    title = "Get more coffee"
    title2 = "Work on teamproject"
    title3 = "Get two days free"
    create_todo(title)
    create_todo(title2)
    create_todo(title3)
    check('todo-1')
    check('todo-2')
  end

  scenario 'We can add a new task' do
    title = "Get more coffee"
    create_todo(title)
    #now test #2 A new task is displayed in the list of tasks
    expect(page).to have_content('Get more coffee')
  end

  scenario ' If counter updates after creating new todo' do
    title = "I want a cheeseburger"
    create_todo(title)
    sleep 2
    expect( page.find(:css, 'span#todo-count').text ).to eq "1"
  end

  scenario "The completed counter updates when completing task" do
    title = "Get more coffee"
    create_todo(title)
    check('todo-1')
    sleep 2
    expect( page.find(:css, 'span#todo-count').text ).to eq "0"
    expect( page.find(:css, 'span#completed-count' ).text ).to eq "1"
  end

  scenario "Create multiple tasks, complete 2 and check all counters" do
    create_multiple()
    sleep 2
    expect( page.find(:css, 'span#todo-count').text ).to eq "1"
    expect( page.find(:css, 'span#completed-count' ).text ).to eq "2"
    expect( page.find(:css, 'span#total-count').text ).to eq "3"
  end

  scenario "Create multiple tasks, completed some and cleanup" do
    create_multiple()
    sleep 2
    click_link("clean-up")
    sleep 1
    expect( page.find(:css, 'span#todo-count').text ).to eq "1"
    expect( page.find(:css, 'span#completed-count' ).text ).to eq "0"
    expect( page.find(:css, 'span#total-count').text ).to eq "1"
  end
end
