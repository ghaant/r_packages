class AddCranPackageIdToPackageVersions < ActiveRecord::Migration[8.1]
  def change
    add_reference :package_versions, :cran_package, null: false, index: false

    add_foreign_key :package_versions,
      :cran_packages,
      column: :cran_package_id,
      name: "fk_package_versions_cran_package_id"

    add_index :package_versions,
      :cran_package_id,
      name: "ix_package_versions_cran_package_id"
  end
end
