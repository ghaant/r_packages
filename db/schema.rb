# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_08_23_125420) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "contributors", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "ux_contributors_email", unique: true
  end

  create_table "cran_packages", force: :cascade do |t|
    t.string "author"
    t.datetime "created_at", null: false
    t.datetime "date_publication"
    t.string "description"
    t.string "maintainer"
    t.string "package"
    t.string "title"
    t.datetime "updated_at", null: false
    t.string "version"
  end

  create_table "package_version_contributors", force: :cascade do |t|
    t.bigint "contributor_id", null: false
    t.datetime "created_at", null: false
    t.boolean "is_author", default: false, null: false
    t.boolean "is_maintainer", default: false, null: false
    t.bigint "package_version_id", null: false
    t.datetime "updated_at", null: false
    t.index ["is_author", "is_maintainer"], name: "ix_package_version_contributors_is_author_is_maintainer"
    t.index ["package_version_id", "contributor_id"], name: "ux_package_version_ctrbtrs_package_version_id_contributor_id", unique: true
  end

  create_table "package_versions", force: :cascade do |t|
    t.bigint "cran_package_id", null: false
    t.datetime "created_at", null: false
    t.bigint "package_id", null: false
    t.datetime "published_at", null: false
    t.datetime "updated_at", null: false
    t.string "version", null: false
    t.index ["cran_package_id"], name: "ix_package_versions_cran_package_id"
    t.index ["package_id", "version"], name: "ux_package_versions_package_id_version", unique: true
  end

  create_table "packages", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "description", null: false
    t.string "name", null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "ux_packages_name", unique: true
  end

  add_foreign_key "package_version_contributors", "contributors", name: "fk_package_version_contributors_contributor_id"
  add_foreign_key "package_version_contributors", "package_versions", name: "fk_package_version_contributors_package_version_id"
  add_foreign_key "package_versions", "cran_packages", name: "fk_package_versions_cran_package_id"
  add_foreign_key "package_versions", "packages", name: "fk_package_versions_package_id"
end
