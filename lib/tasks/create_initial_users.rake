desc 'Create initial users'
task create_initial_users: :environment do
  salud = Organization.create(:title => "Salud")
  sedesol = Organization.create(:title => "Sedesol")
  
  User.create(:name => "Muraly Escalona Conchas", :email => "muraly.escalona@sedesol.gob.mx", :organization_id => sedesol.id, :password => "secretpassword", :password_confirmation => "secretpassword")
  User.create(:name => "José Antolino Orozco Martínez", :email => "jose.orozco@sedesol.gob.mx", :organization_id => sedesol.id, :password => "secretpassword", :password_confirmation => "secretpassword")

  User.create(:name => "Luis Ríos", :email => "luis.rios@salud.gob.mx", :organization_id => salud.id, :password => "secretpassword", :password_confirmation => "secretpassword")
  User.create(:name => "Juan Carlos Reyes Oropeza", :email => "carlos.reyes@salud.gob.mx", :organization_id => salud.id, :password => "secretpassword", :password_confirmation => "secretpassword")
end