library(arrow)
library(tidyverse)

# Data and code in https://github.com/softcite/softcite-extractions-parquet-analysis

## Using read_parquet works as expected

read_parquet('data/softcite-extractions-oa-data/p01_one_percent_random_subset/papers.parquet') |> 
  filter(published_year < 1990) |>
  collect() |>
  nrow()

## [1] 1720

full_papers <- open_dataset('data/softcite-extractions-oa-data/p01_one_percent_random_subset/papers.parquet', format = 'parquet')

# published_year is uint16
# published_date is date32[day]

## Less than does not work as expected.

full_papers |>
  filter(published_year < 1990) |>
  collect() |>
  nrow()

## [1] 0 

## Greater than works as expected.

full_papers |>
  filter(published_year >= 1990) |>
  collect() |>
  nrow()

## [1] 62421 Correctly removes 1720 papers.

## Working with published_date works as expected (but is obviously slower)

full_papers |>
  filter(year(published_date) < 1990) |>
  collect() |>
  nrow()

# [1] 1720

## Things that incorporate less than (such as between) also fail

full_papers |>
  filter(between(published_year, 1990, 2023)) |>
  collect() |>
  nrow()

## [1] 0

# > schema(full_papers)
# Schema
# paper_id: uint32 not null
# softcite_id: string not null
# title: string
# published_year: uint16
# published_date: date32[day]
# publication_venue: string not null
# publisher_name: string
# doi: string not null
# pmcid: string
# pmid: string
# genre: string
# license_type: string
# has_mentions: bool not null
