library(httr)
library(devtools)
library(usethis)
library(tibble)

# Download and extract files
data_url <- "https://www.ars.usda.gov/ARSUserFiles/80400525/Data/SR/SR28/dnload/sr28asc.zip"
data_path <- tempfile(pattern = "usdanutrients28__", fileext = ".zip")
download.file(data_url, destfile = data_path)
file_paths <- unzip(data_path, exdir = tempdir())

# Make database
parse_file <- function(name) {
  path <- file_paths[grepl(file_paths, pattern = name, fixed = TRUE)]
  if (length(path) != 1) {
    stop('Problem finding dataset "', name, '"')
  }
  as_tibble(read.delim(file = path, sep = "^", quote = "~", na.strings = c("^^", "~~"),
                       header = FALSE, stringsAsFactors = FALSE))
}

food <- parse_file("FOOD_DES.txt")
names(food) <- c("food_id", "grp_id", "food", "food_abbr", "common", "manufacturer",
                 "survey", "refuse", "ref_pct", "scientific", "n_factor", "pro_factor", "fat_factor",
                 "carb_factor")
food$survey <- food$survey == "Y"
use_data(food, overwrite = TRUE)

food_group <- parse_file("FD_GROUP.txt")
names(food_group) <- c("grp_id", "group")
use_data(food_group, overwrite = TRUE)

nutrient <- parse_file("NUT_DATA.txt")
names(nutrient) <- c("food_id", "nutr_id", "value", "num_points", "se",
                     "source_type_id", "deriv_id", "impute_id", "fortified", "num_studies", "min",
                     "max", "df", "lwr", "upr", "comments", "modified", "cc")
nutrient$fortified[nutrient$fortified == ""] <- NA
use_data(nutrient, overwrite = TRUE)

nutrient_def <- parse_file("NUTR_DEF.txt")
names(nutrient_def) <- c("nutr_id", "unit", "nutr_abbr", "nutr", "precision", "seq")
use_data(nutrient_def, overwrite = TRUE)

source_type <- parse_file("SRC_CD.txt")
names(source_type) <- c("source_type_id", "source_type")
use_data(source_type, overwrite = TRUE)

deriv <- parse_file("DERIV_CD.txt")
names(deriv) <- c("deriv_id", "deriv")
use_data(deriv, overwrite = TRUE)

weight <- parse_file("WEIGHT.txt")
names(weight) <- c("food_id", "seq", "amount", "desc", "weight",
                   "num_points", "sd")
use_data(weight, overwrite = TRUE)


footnote <- parse_file("FOOTNOTE.txt")
names(footnote) <- c("food_id", "seq", "type", "nutr_id", "footnote")
use_data(footnote, overwrite = TRUE)

reference <- parse_file("DATA_SRC.txt")
names(reference) <- c("ref_id", "authors", "title", "year", "journal", "vol_city",
                      "issue_state", "start_page", "end_page")
use_data(reference, overwrite = TRUE)

nutrient_source <- parse_file("DATSRCLN.txt")
names(nutrient_source) <- c("food_id", "nutr_id", "ref_id")
use_data(nutrient_source, overwrite = TRUE)


