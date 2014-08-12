class AddMailPasswordToWebUser < ActiveRecord::Migration
  def up
  	add_column :web_users, :facebook_email, :string, after: :lastname
  	add_column :web_users, :password, :string, after: :email
  end

  def down
  	remove_column :web_users, :password
  	remove_column :web_users, :facebook_email
  end
end
