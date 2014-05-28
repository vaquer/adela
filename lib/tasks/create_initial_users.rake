desc 'Create initial users'
task create_initial_users: :environment do
  puts "Number of users to be created:"
  orgs = STDIN.gets.chomp

  orgs.to_i.times do
    puts "User name:"
    name = STDIN.gets.chomp
    puts "User email:"
    email = STDIN.gets.chomp
    puts "User organization title: ie coneval"
    org = STDIN.gets.chomp
    organization = Organization.friendly.find(org.downcase)

    user = User.create(:name => name, :email => email, :organization_id => organization.id, :password => "secretpassword", :password_confirmation => "secretpassword")
    if user
      puts "*****"
      puts "User #{user.name} created in #{organization.title}"
      puts "*****"
    end
  end
end