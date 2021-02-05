# > PROJECT INFO
# NAME: INTERGENERATIONAL MOBILITY IN BRAZIL
# LEAD: LUCAS WARWAR
#
# > THIS SCRIPT
# AIM: LINK FAMILIES - PHASE I - RECEITA
# AUTHOR: LUCAS WARWAR
#
# > NOTES
# A1: - LINK MOTHER-CHILD USING MOTHER'S NAME FROM RECEITA

# SETUP -----------------------------------------------

source("code/fun/setup.R")

# LOAD FULL RECEITA'S DATASET -------------------

list.files(path_receita, pattern = ".rds")

receita <- readr::read_rds(paste0(path_receita, "A0_registry.rds"))

# 1.) FIND CHILDREN WHOSE MOTHER HAS A UNIQUE NAME ---------------------

# SELECT COLUNS OF INTEREST
receita <- collapse::qDT(receita) %>%
  collapse::fselect(
    uf, cpf, namea, gend, dtbirth, mothernamea, # PERSONAL INFO
    idstreet, stdnumber, stdnumber2, stdcompl, stdcompl2, cep, # ADDRESS
    common_all, ufcommon_all) # NAME'S COMMONESS

# MERGE ATTEMPT 1: MOTHERS WITH UNIQUE NAME IN ALL DATA
mother_child_1 <- data.table::merge.data.table(
  collapse::fselect(receita, uf, cep, cpf, namea, mothernamea, dtbirth, gend),
  collapse::fsubset(receita, common_all == 1)  %>% # UNIQUE NAMES
    collapse::fselect(cpf, namea),
  by.x = "mothernamea",
  by.y = "namea") %>%
  # RENAME AND SELECT COLUMNS
  collapse::frename(cpf.x = cpf, cpf.y = mothercpf) %>%
  collapse::fselect(uf, cep, cpf, namea, gend,
                    dtbirth, mothernamea, mothercpf) %>%
  collapse::roworder(cpf)

# SAVE TEMP FILE
write_rds(mother_child_1,
          here::here("data", "temp", "A1_motherchild_commonall.rds"),
          compress = "gz")

# END OF SCRIPT ---------------------------------------
