class Cran::PackageImporterJob < ApplicationJob
  queue_as :default

  def perform(name, version)
    return false if name.blank? || version.blank?

  description =
      Gem::Package::TarReader.new(
        Zlib::GzipReader.open(URI.open("http://cran.rproject.org/src/contrib/#{name}_#{version}.tar.gz"))
      ).seek("#{name}/DESCRIPTION") { |file| file.read }

  description.lines(chomp: true).map { |line| line.split(': ', 2) }.
    to_h { |sub_array| [sub_array.first.gsub("/", "_"), sub_array.last].map(&:downcase) }.
    select { |key, _value| key.in?(Cran::Package.column_names) }
  end
end
