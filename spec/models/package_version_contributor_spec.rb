require 'rails_helper'

RSpec.describe PackageVersionContributor, type: :model do
  before { create(:package_version_contributor) } # Create a package version contributor to test uniqueness validation

  it { is_expected.to belong_to(:package_version) }
  it { is_expected.to belong_to(:contributor) }

  it { is_expected.to validate_uniqueness_of(:contributor_id).scoped_to(:package_version_id) }
  it { is_expected.to validate_uniqueness_of(:package_version_id).scoped_to(:contributor_id) }
end
