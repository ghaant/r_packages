require 'rails_helper'

RSpec.describe Cran::Package, type: :model do
  it { is_expected.to have_one(:package_version) }

  it 'enqueues a job after creation' do
    test_cran_package = build(:cran_package)

    expect {
      test_cran_package.save!
    }.to have_enqueued_job(Cran::PackageProcessorJob).with(test_cran_package.id)
  end
end
