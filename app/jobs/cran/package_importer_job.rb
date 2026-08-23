class Cran::PackageImporterJob < ApplicationJob
  queue_as :default

  def perform(name, version)
    return false if name.blank? || version.blank?

    description =
      Gem::Package::TarReader.new(
        Zlib::GzipReader.open(URI.open("https://cran.r-project.org/src/contrib/#{name}_#{version}.tar.gz"))
      ).seek("#{name}/DESCRIPTION") { |file| file.read }

    Cran::Package.create!(parse_dcf(description).select { |key, _value| key.in?(Cran::Package.column_names) })
  end

  private

  def parse_dcf(text)
    result = {}
    current_key = nil

    text.each_line(chomp: true) do |line|
      if !line.start_with?("\s")
        split_line = line.split(": ", 2)
        current_key = split_line.first.downcase.gsub("/", "_")
        result[current_key] = split_line.last
      else
        result[current_key] << " " << line.strip
      end
    end

    result
  end
end
