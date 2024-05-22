#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

# test if there is at least one argument: if not, return an error
if (length(args)==0) {
    stop("At least one argument must be supplied (input file).n", call.=FALSE)
}

library(readr)
library(dplyr)
library(glue)
library(stringr)

df <- read_csv(args[1])

df <- df %>%
    group_by(cell_id) %>%
    mutate(cell_int = cur_group_id())

# Check that each cells is only there once
df_count <- df %>%
    count(cell_int, cell_id) %>%
    count(cell_id)

table(df_count$n)

# create output filename
fn <- str_replace(string = args[1], pattern = ".csv$", replacement = "_mod.csv")
message(glue("returning {fn}"))

readr::write_csv(df, file = fn)