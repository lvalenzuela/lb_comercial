class RenameCourseMemberContactPersonIdColumn < ActiveRecord::Migration
  def up
  	rename_column :course_members, :contact_person_id, :web_user_id
  end

  def down
  	rename_column :course_members, :web_user_id, :contact_person_id
  end
end
