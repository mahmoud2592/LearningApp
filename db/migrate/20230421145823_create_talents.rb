class CreateTalents < ActiveRecord::Migration[7.0]
  def change
    create_table :talents do |t|
      t.string :name
      t.text :description
      t.integer :category
      t.integer :level
      t.string :website_url

      t.timestamps
    end
  end
end
