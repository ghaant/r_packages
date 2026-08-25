require 'rails_helper'

RSpec.describe PackageVersion, type: :model do
  before { create(:package_version) } # Create a package version to test uniqueness validation

  it { is_expected.to belong_to(:package) }
  it { is_expected.to belong_to(:cran_package).class_name('Cran::Package') }
  it { is_expected.to have_many(:package_version_contributors).dependent(:destroy) }
  it { is_expected.to have_many(:contributors).through(:package_version_contributors) }

  it { is_expected.to validate_presence_of(:version) }
  it { is_expected.to validate_presence_of(:published_at) }
  it { is_expected.to validate_uniqueness_of(:version).scoped_to(:package_id).case_insensitive }
end
