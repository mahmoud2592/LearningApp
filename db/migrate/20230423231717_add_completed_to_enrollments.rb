class AddCompletedToEnrollments < ActiveRecord::Migration[7.0]
  def up
    add_column :enrollments, :completed, :boolean, default: false, null: false
  end

  def down
    remove_column :enrollments, :completed
  end
end
