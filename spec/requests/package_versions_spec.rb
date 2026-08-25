require 'rails_helper'

RSpec.describe "PackageVersions", type: :request do
  describe "GET /package_versions/index" do
    it "returns http success" do
      get "/package_versions/index"

      expect(response).to have_http_status(:success)
    end

    it "displays package versions ordered by package name and version descending" do
      alpha = create(:package, name: "Alpha", title: "Alpha package", description: "Alpha description")
      bravo = create(:package, name: "Bravo", title: "Bravo package", description: "Bravo description")

      contributor = create(:contributor, name: "Jane Doe", email: "jane@example.com")

      older_bravo_version = create(:package_version,
        package: bravo,
        version: "1.0.0",
        published_at: 2.days.ago)
      newer_bravo_version = create(:package_version,
        package: bravo,
        version: "2.0.0",
        published_at: 1.day.ago)
      alpha_version = create(:package_version,
        package: alpha,
        version: "1.5.0",
        published_at: 3.days.ago)

      create(:package_version_contributor,
        package_version: older_bravo_version,
        contributor: contributor,
        is_author: true,
        is_maintainer: false)
      create(:package_version_contributor,
        package_version: newer_bravo_version,
        contributor: contributor,
        is_author: false,
        is_maintainer: true)
      create(:package_version_contributor,
        package_version: alpha_version,
        contributor: contributor,
        is_author: true,
        is_maintainer: true)

      get "/package_versions/index"

      expect(response).to have_http_status(:success)
      expect(response.body.index(alpha.name)).to be < response.body.index(bravo.name)
      expect(response.body.index(newer_bravo_version.version)).to be < response.body.index(older_bravo_version.version)
      expect(response.body).to include("Jane Doe")
    end
  end
end
