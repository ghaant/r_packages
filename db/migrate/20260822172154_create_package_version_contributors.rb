class CreatePackageVersionContributors < ActiveRecord::Migration[8.1]
  def change
    create_table :package_version_contributors do |t|
      t.references :package_version, null: false
      t.references :contributor, null: false
      t.boolean :is_author, default: false, null: false
      t.boolean :is_maintainer, default: false, null: false
      t.timestamps
    end

    add_index :package_version_contributors,
      [:package_version_id, :contributor_id],
      unique: true,
      name: "ux_package_version_ctrbtrs_package_version_id_contributor_id"

    add_index :package_version_contributors,
      [:is_author, :is_maintainer],
      name: "ix_package_version_contributors_is_author_is_maintainer"

    add_foreign_key :package_version_contributors,
      :package_versions,
      column: :package_version_id,
      name: "fk_package_version_contributors_package_version_id"

    add_foreign_key :package_version_contributors,
      :contributors,
      column: :contributor_id,
      name: "fk_package_version_contributors_contributor_id"
  end
end
