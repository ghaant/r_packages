require 'rails_helper'

RSpec.describe Cran::PackageListCheckerJob, type: :job do
  describe '#perform' do
    let(:packages_file) do
      <<~PACKAGES
        Package: dplyr
        Version: 1.2.3

        Package: ggplot2
        Version: 3.4.0

        Package: tibble
        Version: 5.0.0
      PACKAGES
    end

    before { allow(Down).to receive(:download).and_return(double(read: packages_file)) }

    it 'enqueues importer jobs for package versions not already present' do
      create(:package, name: 'dplyr')
      create(:package_version, package: Package.find_by!(name: 'dplyr'), version: '1.2.3')

      expect { described_class.perform_now }.
        to have_enqueued_job(Cran::PackageImporterJob).with('ggplot2', '3.4.0')
        .and have_enqueued_job(Cran::PackageImporterJob).with('tibble', '5.0.0')
    end

    context 'when a package already exists' do
      let!(:package) { create(:package, name: 'ggplot2') }

      context 'with the same version' do
        let!(:package_version) { create(:package_version, package: package, version: '3.4.0') }

        it 'does not enqueue an importer job for that package version' do
          expect { described_class.perform_now }.not_to have_enqueued_job(Cran::PackageImporterJob).with('ggplot2', '3.4.0')
        end
      end

      context 'with a different version' do
        let!(:package_version) { create(:package_version, package: package, version: '2.9.0') }

        it 'enqueues an importer job for the new version' do
          expect { described_class.perform_now }.to have_enqueued_job(Cran::PackageImporterJob).with('ggplot2', '3.4.0')
        end
      end
    end
  end
end
