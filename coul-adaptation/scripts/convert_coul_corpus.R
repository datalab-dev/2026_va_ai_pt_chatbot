library(dplyr)
library(jsonlite)
library(readr)

source("coul-adaptation/scripts/populate_df.R")

corpus_dir = "coul-adaptation/data/text-data-complete"
my_files = dir(corpus_dir)

my_dfs = lapply(file.path(corpus_dir, my_files), populate_df)

big_df = bind_rows(my_dfs)

write_csv(big_df, file = "coul-adaptation/output/coul-corpus.csv")
