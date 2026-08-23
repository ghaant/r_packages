class CreatePackageVersions < ActiveRecord::Migration[8.1]
  def change
    create_table :package_versions do |t|
      t.references :package, null: false, index: false
      t.string :version, null: false
      t.datetime :published_at, null: false
      t.timestamps
    end

    add_index :package_versions, [:package_id, :version], unique: true, name: "ux_package_versions_package_id_version"
    add_foreign_key :package_versions, :packages, column: :package_id, name: "fk_package_versions_package_id"
  end
end
