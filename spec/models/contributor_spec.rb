require 'rails_helper'

RSpec.describe Contributor, type: :model do
  before { create(:contributor) } # Create a contributor to test uniqueness validation

  it { is_expected.to have_many(:package_version_contributors) }
  it { is_expected.to have_many(:package_versions).through(:package_version_contributors) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name) }
end
