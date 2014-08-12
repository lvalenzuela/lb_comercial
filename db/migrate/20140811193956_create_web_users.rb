class CreateWebUsers < ActiveRecord::Migration
  def up
    create_table :web_users do |t|
      t.string :uid
      t.string :name
    	t.string :firstname
    	t.string :lastname
    	t.string :email
    	t.string :gender
    	t.string :location
    	t.string :oauth_token
    	t.datetime :oauth_expires_at
    	t.string :provider
    	t.string :zoho_contact_person_id
    	t.string :zoho_contact_id
    	t.integer :moodle_id
    	t.string :zoho_enabled
    	t.string :moodle_enabled
    	t.integer :test_score
      t.string :course_level
      t.timestamps
    end
  end

  def down
  	drop_table :web_users
  end
end
