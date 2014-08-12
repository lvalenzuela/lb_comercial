class AddPhoneAndMobileToWebUsers < ActiveRecord::Migration
  def up
  	add_column :web_users, :phone, :string, after: :gender
  	add_column :web_users, :mobile, :string, after: :phone
  end

  def down
  	remove_column :web_users, :phone
  	remove_column :web_users, :mobile
  end
end
