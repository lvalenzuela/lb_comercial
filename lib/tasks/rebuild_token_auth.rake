namespace :contact_person do
  desc "Rebuild Auth-Tokens"
  task :rebuild_auth_token => :environment do
    ContactPerson.transaction do
      ContactPerson.all.each { |u|
        u.generate_token(:auth_token)
        u.save!
      }
    end
  end
end