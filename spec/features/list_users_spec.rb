require 'spec_helper'

describe "Viewing the list of users" do

  it "shows the users" do
    user1 = User.create!(user_attributes(name: "Larry", username:"nickname1", email: "larry@example.com", password: "12345678901", password_confirmation: "12345678901"))
    user2 = User.create!(user_attributes(name: "Moe", username:"nickname2", email: "moe@example.com", password: "12345678901", password_confirmation: "12345678901"))
    user3 = User.create!(user_attributes(name: "Curly", username:"nickname3", email: "curly@example.com", password: "12345678901", password_confirmation: "12345678901"))

		sign_in(user1)

    visit users_url

    expect(page).to have_link(user1.username)
    expect(page).to have_link(user2.username)
    expect(page).to have_link(user3.username)
  end

end