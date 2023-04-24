class AddCompletedToCourseTalent < ActiveRecord::Migration[7.0]
  def up
    add_column :course_talents, :completed, :boolean, default: false, null: true
  end

  def down
    remove_column :course_talents, :completed
  end
end
