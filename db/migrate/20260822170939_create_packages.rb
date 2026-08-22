class CreatePackages < ActiveRecord::Migration[8.1]
  def change
    create_table :packages do |t|
      t.string :name, null: false
      t.string :title, null: false
      t.string :description, null: false
      t.timestamps
    end

    add_index :packages, :name, unique: true, name: "ux_packages_name"
  end
end
