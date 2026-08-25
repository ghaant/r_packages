require 'rails_helper'

RSpec.describe Package, type: :model do
  before { create(:package) } # Create a package to test uniqueness validation

  it { is_expected.to have_many(:package_versions) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name) }
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:description) }
end
