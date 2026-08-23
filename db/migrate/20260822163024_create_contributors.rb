class CreateContributors < ActiveRecord::Migration[8.1]
  def change
    create_table :contributors do |t|
      t.string :email, null: true
      t.string :name, null: false
      t.timestamps
    end

    # Unfortunately on CRAN emails are stated only for maintainers, but not for authors.
    # So we have to believe that the name is unique and use it as a key to find the contributor.
    add_index :contributors, :name, unique: true, name: "ux_contributors_name"
  end
end
