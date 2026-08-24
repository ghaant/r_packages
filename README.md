# R-Packages

A Ruby on Rails application for listing packages published on [CRAN](https://cran.r-project.org/).

It imports package metadata from a CRAN `PACKAGES` file and each package's `DESCRIPTION` file daily at 12 p.m., stores all discovered versions, and exposes a simple web interface for listing packages.

## Features

- Imports package names and versions from a CRAN `PACKAGES` file.
- Downloads and parses each package archive's `DESCRIPTION` file.
- Stores package metadata:
  - Name
  - Version
  - Publication date
  - Title
  - Description
  - Authors
  - Maintainers
- Stores author and maintainer names and email addresses when available.
- Preserves multiple versions of the same package.
- Provides a web page listing indexed packages.

## Technology

- Ruby 4.x
- Rails 8
- PostgreSQL
- RSpec
- Solid Queue or the scheduling mechanism configured by the application
