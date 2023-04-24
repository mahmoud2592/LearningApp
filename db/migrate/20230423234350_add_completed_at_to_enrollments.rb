class AddCompletedAtToEnrollments < ActiveRecord::Migration[7.0]
  def up
    add_column :enrollments, :completed_at, :date
  end

  def down
    remove_column :enrollments, :completed_at
  end
end

