# > PROJECT INFO
# NAME: INTERGENERATIONAL MOBILITY IN BRAZIL
# LEAD: LUCAS WARWAR
#
# > THIS SCRIPT
# AIM: LINK FAMILIES - PHASE I - RECEITA
# AUTHOR: LUCAS WARWAR
#
# > NOTES
# A2: - LINK FATHER-CHILD USING DEPENDENTS' FROM RECEITA

# SETUP -----------------------------------------------

source("code/fun/setup.R")

# LOAD DATA -------------------

list.files(path_receita, pattern = ".rds")

# PEOPLE FILLED AS DEPENDENT FROM 2006 - 2017
dependents <- readr::read_rds(paste0(path_receita, "A0_dependents.rds")) %>%
    collapse::qDT() %>%
    collapse::ftransform(cpf = bit64::as.integer64.double(cpf),
                         dep_cpf = bit64::as.integer64.double(dep_cpf))

# FULL RECEITA'S DATASET
receita <- readr::read_rds(paste0(path_receita, "A0_registry.rds"))

# SELECT COLUNS OF INTEREST
receita <- collapse::qDT(receita) %>%
  collapse::fselect(
    uf, cep, cpf, namea, gend, dtbirth, mothernamea) # PERSONAL INFO

# MERGE ATTEMPT 1: NAME AND CPF
father_child_1 <- data.table::merge.data.table(
    receita,
    collapse::fselect(dependents, -year, -dep_dtbirth) %>%
        collapse::funique(),
    by.x = c("cpf", "namea"),
    by.y = c("dep_cpf", "dep_namea")) %>%
    collapse::frename(cpf.x = cpf, cpf.y = fathercpf) %>%
    collapse::fselect(uf, cep, cpf, namea, gend, dtbirth,
                      mothernamea, fathercpf, dep_type) %>%
    collapse::roworder(cpf)

# MERGE ATTEMPT 2: ONLY CPF
father_child_2 <- data.table::merge.data.table(
    collapse::fsubset(receita,
                      cpf %nin% father_child_1$cpf),
    collapse::fselect(dependents, -year, -dep_dtbirth, -dep_namea) %>%
        collapse::funique(),
    by.x = "cpf",
    by.y = "dep_cpf") %>%
    collapse::frename(cpf.x = cpf, cpf.y = fathercpf) %>%
    collapse::fselect(uf, cep, cpf, namea, gend, dtbirth,
                      mothernamea, fathercpf, dep_type) %>%
    collapse::roworder(cpf)

# BIND ROWS DEPENDENTS' MERGE BATCH (1-3)
father_child_dep <- data.table::rbindlist(
  list(father_child_1, father_child_2))

rm(father_child_1, father_child_2)

# LOAD PEOPLE LINKED WITH THEIR MOTHERS IN PHASE 1A
mother_child <- readr::read_rds(
                here::here("data", "temp", "A1_motherchild_receita.rds")) %>%
                collapse::qDT()

##### NEED TO CHECK NO OF MERGES BEFORE THIS STEP #####

# MERGE MOTHER_FATHER

# CHECK IF MOTHER IS THE FILLER
father_child_dep <- father_child_dep %>%
    collapse::ftransform(dep_check = ifelse())

# SAVE TEMP FILE
write_rds(collapse::roworder(father_child_dep, cpf),
          here::here("data", "temp", "A2_fatherchild_dep.rds"),
          compress = "gz")