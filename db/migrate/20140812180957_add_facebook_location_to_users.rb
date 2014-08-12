class AddFacebookLocationToUsers < ActiveRecord::Migration
  def up
  	add_column :web_users, :facebook_location, :string, after: :location
  	change_column :web_users, :course_level, :integer
  	rename_column :web_users, :course_level, :course_level_id
  end

  def down
  	remove_column :web_users, :facebook_location
  	change_column :web_users, :course_level_id, :string
  	rename_column :web_users, :course_level_id, :course_level
  end
end
