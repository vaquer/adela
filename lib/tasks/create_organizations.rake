desc 'Create organizations'
task create_organizations: :environment do
  puts "Organizations titles separated by comma: Title1, Title2"
  orgs = STDIN.gets.chomp

  orgs.split(',').each do |title|
    org = Organization.create(:title => title.strip)
    if org
      puts "#{org.title} created with id: #{org.id}"
    end
  end
end