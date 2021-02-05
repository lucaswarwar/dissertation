# > PROJECT INFO
# NAME: INTERGENERATIONAL MOBILITY IN BRAZIL
# LEAD: LUCAS WARWAR
#
# > THIS SCRIPT
# AIM: LINK FAMILIES - PHASE I - RECEITA
# AUTHOR: LUCAS WARWAR
#
# > NOTES
# A3: - LINK MOTHER-CHILD USING UFNAMES FROM RECEITA

# SETUP -----------------------------------------------

source("code/fun/setup.R")

# LOAD FULL RECEITA'S DATASET -------------------

list.files(path_receita, pattern = ".rds")

receita <- readr::read_rds(paste0(path_receita, "A0_registry.rds")) %>%
  collapse::qDT() %>%
  collapse::fselect(
    cpf, namea, gend, dtbirth, mothernamea) # PERSONAL INFO


# 1.) FIND CHILDREN WHOSE MOTHER HAS UNIQUE NAME IN UF --------------

# MERGE ATTEMPT 1: MOTHERS WITH UNIQUE NAME IN ALL DATA
mother_child_ufcommonall <- data.table::merge.data.table(
  collapse::fsubset(receita,
                    cpf %nin% mother_child_commonall$cpf &
                    cpf %nin% mother_child_address$cpf),
  collapse::fsubset(receita, ufcommon_all == 1)  %>% # UNIQUE NAMES
    collapse::fselect(cpf, uf, namea, dtbirth),
  by.x = c("mothernamea", "uf"),
  by.y = "namea", "uf") %>%
  # RENAME AND SELECT COLUMNS
  collapse::frename(cpf.x = cpf, cpf.y = mothercpf,
                    dtbirth.x = dtbirth, dtbirth.y = motherdtbirth) %>%
  collapse::fselect(uf, cep, cpf, namea, gend, dtbirth,
                    mothernamea, mothercpf, motherdtbirth) %>%
  collapse::fsubset( # FEMALE MUST BE 10-55 TO HAVE CHILDREN
    as.numeric(stringr::str_sub(motherdtbirth, 6, 9)) -
    as.numeric(stringr::str_sub(dtbirth, 6, 9)) %in%  c(10:55)) %>%
  collapse::roworder(cpf)

# SAVE TEMP FILE
write_rds(mother_child_ufcommonall,
          here::here("data", "temp", "A1_motherchild_ufcommonall.rds"),
          compress = "gz")

# 5.) COMBINE FILES AND SAVE PHASE 1A
files <- list.files(here::here("data", "temp"))

mother_child_receita <- purrr::map(files, readr::read_rds) %>%
  data.table::rbindlist() %>%
  collapse::roworder(cpf) %>%
  readr::write_rds(here::here("data", "temp", "A1_motherchild_receita.rds"),
                   compress = "gz")

file.remove(paste0("data/temp/", files))