class CreateContributors < ActiveRecord::Migration[8.1]
  def change
    create_table :contributors do |t|
      t.string :email, null: false
      t.string :name, null: false
      t.timestamps
    end

    add_index :contributors, :email, unique: true, name: "ux_contributors_email"
  end
end
