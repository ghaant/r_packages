class CreateCranPackages < ActiveRecord::Migration[8.1]
  def change
    create_table :cran_packages do |t|
      t.string :package, null: true
      t.string :version, null: true
      t.string :title, null: true
      t.string :author, null: true
      t.string :maintainer, null: true
      t.string :description, null: true
      t.datetime :date_publication, null: true
      t.timestamps
    end
  end
end
