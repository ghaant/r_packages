require 'rails_helper'

RSpec.describe Cran::PackageProcessorJob, type: :job do
  describe '#perform' do
    let!(:cran_package) do
      create :cran_package,
        package: 'dplyr',
        version: '1.2.3',
        title: 'A Grammar of Data Manipulation',
        description: 'A package for data manipulation.',
        author: 'Alice Smith [cre], Bob Jones [ctb]',
        maintainer: 'Alice Smith <alice@example.com>',
        date_publication: 2.days.ago
    end

    context 'the data is valid and not yet present in the database' do
      it 'creates the package, version, and contributor records for a new cran package' do
        expect { described_class.perform_now(cran_package.id) }.
          to change(Package, :count).by(1).
          and change(PackageVersion, :count).by(1).
          and change(PackageVersionContributor, :count).by(2).
          and change(Contributor, :count).by(2)

        package = Package.find_by!(name: 'dplyr')

        expect(package.title).to eq('A Grammar of Data Manipulation')
        expect(package.description).to eq('A package for data manipulation.')

        package_version = cran_package.package_version

        expect(package_version.package).to eq(package)
        expect(package_version.version).to eq('1.2.3')
        expect(package_version.published_at).to eq(cran_package.date_publication)

        alice = Contributor.find_by!(name: 'Alice Smith')
        bob = Contributor.find_by!(name: 'Bob Jones')

        expect(alice.email).to eq('alice@example.com')
        expect(bob.email).to be_nil

        alice_link = PackageVersionContributor.find_by!(package_version: package_version, contributor: alice)
        bob_link = PackageVersionContributor.find_by!(package_version: package_version, contributor: bob)

        expect(alice_link.is_author).to be(true)
        expect(alice_link.is_maintainer).to be(true)
        expect(bob_link.is_author).to be(true)
        expect(bob_link.is_maintainer).to be(false)
      end
    end

    context 'when the cran package already has an associated package version' do
      before { create(:package_version, cran_package: cran_package) }

      it 'does nothing' do
        expect { described_class.perform_now(cran_package.id) }.
          to change(Package, :count).by(0).
          and change(PackageVersion, :count).by(0)
      end
    end

    context 'when the same package name and version already exist' do
      before do
        package =
          create :package,
            name: 'dplyr',
            title: 'A Grammar of Data Manipulation',
            description: 'A package for data manipulation.'

        create(:package_version, package: package, version: '1.2.3')
      end

      it 'does nothing' do
        expect { described_class.perform_now(cran_package.id) }.not_to change(PackageVersion, :count)
      end
    end

    context 'when the cran package has no maintainer email' do
      before { cran_package.update!(maintainer: 'Alice Smith') }

      it 'does not mark any contributor as a maintainer' do
        expect { described_class.perform_now(cran_package.id) }.to change(PackageVersionContributor, :count).by(2)

        alice = Contributor.find_by!(name: 'Alice Smith')

        expect(alice.email).to be_nil

        alice_link =
          PackageVersionContributor.find_by!(package_version: cran_package.package_version, contributor: alice)

        expect(alice_link.is_author).to be(true)
        expect(alice_link.is_maintainer).to be(false)
      end
    end

    context 'when the maintainer is not listed as an author' do
      before { cran_package.update!(author: 'Bob Jones [ctb]') }

      it 'creates a contributor for the maintainer and marks them as a maintainer' do
        expect { described_class.perform_now(cran_package.id) }.to change(PackageVersionContributor, :count).by(2)

        alice = Contributor.find_by!(name: 'Alice Smith')
        bob = Contributor.find_by!(name: 'Bob Jones')

        expect(alice.email).to eq('alice@example.com')
        expect(bob.email).to be_nil

        alice_link = PackageVersionContributor.find_by!(package_version: cran_package.package_version, contributor: alice)
        bob_link = PackageVersionContributor.find_by!(package_version: cran_package.package_version, contributor: bob)

        expect(alice_link.is_author).to be(false)
        expect(alice_link.is_maintainer).to be(true)
        expect(bob_link.is_author).to be(true)
        expect(bob_link.is_maintainer).to be(false)
      end
    end
  end
end
