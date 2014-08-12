class ChangeZohoEnabledMoodleEnabledOnUsers < ActiveRecord::Migration
  def up
  	change_column :web_users, :zoho_enabled, :boolean, :default => false
  	change_column :web_users, :moodle_enabled, :boolean, :default => false
  end

  def down
  	change_column :web_users, :zoho_enabled, :string
  	change_column :web_users, :moodle_enabled, :string
  end
end
