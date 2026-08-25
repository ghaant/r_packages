require 'rails_helper'

RSpec.describe Cran::PackageImporterJob, type: :job do
  describe '#perform' do
    let!(:description) do
      <<~DESC
        Package: dplyr
        Type: Package
        Depends: R (>= 3.5.0)
        Authors@R: c(
          person("Alice", "Smith",
            role = c("aut", "cre"),
            email = "alice@example.com")
        )
        URL: https://dplyr.tidyverse.org
        Import: methods, stats, utils
        Suggests: testthat, knitr, rmarkdown
        Encoding: UTF-8
        LazyData: true
        RoxygenNote: 7.1.1
        Version: 1.2.3
        Title: A Grammar of Data Manipulation
        Description: A package for data manipulation.
          It supports transforms and joins.
        Author: Alice Smith [aut], Bob Jones [ctb]
        Maintainer: Alice Smith <alice@example.com>
        Date/Publication: 2024-01-01
        License: MIT
      DESC
    end

    let!(:tar_reader) { instance_double(Gem::Package::TarReader) }

    before do
      allow(Down).to receive(:download).and_return('/tmp/dplyr_1.2.3.tar.gz')
      allow(Zlib::GzipReader).to receive(:open).and_return(double('gzip_reader'))
      allow(Gem::Package::TarReader).to receive(:new).and_return(tar_reader)
      allow(tar_reader).to receive(:seek).with('dplyr/DESCRIPTION').and_yield(StringIO.new(description))
    end

    it 'creates a cran package from the downloaded DESCRIPTION file' do
      expect { described_class.perform_now('dplyr', '1.2.3') }.to change(Cran::Package, :count).by(1)

      cran_package = Cran::Package.last
      expect(cran_package.package).to eq('dplyr')
      expect(cran_package.version).to eq('1.2.3')
      expect(cran_package.title).to eq('A Grammar of Data Manipulation')
      expect(cran_package.description).to eq('A package for data manipulation. It supports transforms and joins.')
      expect(cran_package.author).to eq('Alice Smith [aut], Bob Jones [ctb]')
      expect(cran_package.maintainer).to eq('Alice Smith <alice@example.com>')
      expect(cran_package.date_publication).to eq(Date.new(2024, 1, 1))
    end

    it 'returns false when the package name is blank' do
      expect(described_class.perform_now('', '1.2.3')).to be(false)
    end

    it 'returns false when the version is blank' do
      expect(described_class.perform_now('dplyr', '')).to be(false)
    end

    it 'returns false when the downloaded description is blank' do
      allow(tar_reader).to receive(:seek).with('dplyr/DESCRIPTION').and_yield(StringIO.new(''))

      expect(described_class.perform_now('dplyr', '1.2.3')).to be(false)
    end
  end

  describe '#parse_dcf' do
    it 'keeps continuation lines attached to the previous field' do
      job = described_class.new

      text = <<~DESC
        Authors@R: c(
                  person("Federico M.", "Stefanini",
                          email = "federico.stefanini@unimi.it",
                          role  = c("arc","aut")),
                  person("Massimiliano","Mascherini",
                          email = "massimiliano.mascherini@eurofound.europa.eu",
                          role  = c("arc")),
                  person("Eleonora Peruffo",
                  email="eleonora.peruffo@eurofound.europa.eu",
                  role = c("cre")),
                  person("Nedka Nikiforova", role = c("ctb")),
                  person("Chiara Litardi", role = c("ctb")),
                  person("Berta Mizsei", role= c("ctb")),
                  person("Ricardo Simon-Carbajo", role= c("ctb")),
                  person("Romila Ghosh", role= c("ctb")),
                  person("Andres Suarez-Cetrulo", role= c("ctb"))
                  )
        Maintainer: Eleonora Peruffo <eleonora.peruffo@eurofound.europa.eu>
        URL:
                https://www.eurofound.europa.eu/system/files/2022-04/introduction-to-the-convergeu-package-0.6.4-tutorial-v2-apr2022.pdf,
                https://www.eurofound.europa.eu/en/publications/eurofound-paper/2020/monitoring-upward-convergence-eu-r-convergeu-package,
                https://www.eurofound.europa.eu/en/publications/2018/upward-convergence-eu-concepts-measurements-and-indicators,
                https://www.ajs.or.at/index.php/ajs/article/view/1468
      DESC

      result = job.send(:parse_dcf, text)

      expect(result['Authors@R']).to eq(
        'c( person("Federico M.", "Stefanini", email = "federico.stefanini@unimi.it", role  = c("arc","aut")), ' \
        'person("Massimiliano","Mascherini", email = "massimiliano.mascherini@eurofound.europa.eu", ' \
        'role  = c("arc")), person("Eleonora Peruffo", email="eleonora.peruffo@eurofound.europa.eu", ' \
        'role = c("cre")), person("Nedka Nikiforova", role = c("ctb")), person("Chiara Litardi", role = c("ctb")), ' \
        'person("Berta Mizsei", role= c("ctb")), person("Ricardo Simon-Carbajo", role= c("ctb")), ' \
        'person("Romila Ghosh", role= c("ctb")), person("Andres Suarez-Cetrulo", role= c("ctb")) )'
      )
      expect(result['Maintainer']).to eq('Eleonora Peruffo <eleonora.peruffo@eurofound.europa.eu>')
      expect(result['URL']).to eq(
        ' https://www.eurofound.europa.eu/system/files/2022-04/introduction-to-the-convergeu-package-0.6.4-tutorial-v2-apr2022.pdf, ' \
        'https://www.eurofound.europa.eu/en/publications/eurofound-paper/2020/monitoring-upward-convergence-eu-r-convergeu-package, ' \
        'https://www.eurofound.europa.eu/en/publications/2018/upward-convergence-eu-concepts-measurements-and-indicators, ' \
        'https://www.ajs.or.at/index.php/ajs/article/view/1468')
    end
  end
end
