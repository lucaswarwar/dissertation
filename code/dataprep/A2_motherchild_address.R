# > PROJECT INFO
# NAME: INTERGENERATIONAL MOBILITY IN BRAZIL
# LEAD: LUCAS WARWAR
#
# > THIS SCRIPT
# AIM: LINK FAMILIES - PHASE I - RECEITA
# AUTHOR: LUCAS WARWAR
#
# > NOTES
# A1: - LINK MOTHER-CHILD USING ADDRESS FROM RECEITA

# SETUP -----------------------------------------------

source("code/fun/setup.R")

# LOAD FULL RECEITA'S DATASET -------------------

list.files(path_receita, pattern = ".rds")

receita <- readr::read_rds(paste0(path_receita, "A0_registry.rds")) %>%
  collapse::qDT() %>%
  collapse::fselect(
    cpf, namea, gend, dtbirth, mothernamea) # PERSONAL INFO

# 1.) PREPARE ADDRESS DATA -------------
address <- readr::read_rds(paste0(path_receita, "A0_addresshist.rds")) %>%
  collapse::qDT()

# BRING RECEITA INFO
address <- data.table::merge.data.table(
  address,
  receita,
  all.x = TRUE,
  by = cpf)

rm(receita)

# LOAD PREVIUS CHILD-MOTHER LINKS
motherchild_commonall <- readr::read_rds(
  here::here("data", "temp", "A1_motherchild_commonall.rds")) %>%
  collapse::qDT() %>%
  collapse::fselect(cpf)

# 2.) MERGE MOTHERS LIVING IN THE SAME ADDRESS ------------------

# MERGE ATTEMPT 1: FULL ADDRESS
motherchild_address1 <- data.table::merge.data.table(
  collapse::fsubset(address, # EXCLUDE CPFs LINKED IN MERGE 1
                    cpf %nin% motherchild_commonall$cpf),
  collapse::fselect(address,
                    cpf, namea, year, idstreet, stdnumber, stdnumber2,
                    stdcompl, stdcompl2, cep), # ALL POSSIBLE MATCHES
  by.x = c("mothernamea", "year", "idstreet", "stdnumber",
           "stdnumber2", "stdcompl", "stdcompl2", "cep"),
  by.y = c("namea",  "year", "idstreet", "stdnumber",
           "stdnumber2", "stdcompl", "stdcompl2", "cep")) %>%
  # RENAME AND SELECT COLUMNS
  collapse::frename(cpf.x = cpf, cpf.y = mothercpf) %>%
  collapse::fselect(uf, cep, cpf, namea, gend,
                    dtbirth, mothernamea, mothercpf) %>%
  collapse::roworder(cpf) %>%
  collapse::funique()

# MERGE ATTEMPT 2: ADDRESS W/O 2ND NUMBER AND COMPLEMENT
motherchild_address2 <- data.table::merge.data.table(
  collapse::fsubset(address, # EXCLUDE CPFs LINKED IN MERGE 1
                    cpf %nin% motherchild_commonall$cpf &
                    cpf %nin% motherchild_address1$cpf),
  collapse::fselect(address,
                    cpf, namea, year, idstreet,
                    stdnumber, stdcompl, cep), # ALL POSSIBLE MATCHES
  by.x = c("mothernamea", "year", "idstreet",
           "stdnumber", "stdcompl", "cep"),
  by.y = c("namea", "year", "idstreet",
           "stdnumber", "stdcompl", "cep")) %>%
  # RENAME AND SELECT COLUMNS
  collapse::frename(cpf.x = cpf, cpf.y = mothercpf) %>%
  collapse::fselect(uf, cep, cpf, namea, gend,
                    dtbirth, mothernamea, mothercpf) %>%
  collapse::roworder(cpf) %>%
  collapse::funique()

# MERGE ATTEMPT 3: ADDRESS W/O COMPLEMENT
motherchild_address3 <- data.table::merge.data.table(
  collapse::fsubset(address, # EXCLUDE CPFs LINKED IN MERGE 1
                    cpf %nin% motherchild_commonall$cpf &
                    cpf %nin% motherchild_address1$cpf &
                    cpf %nin% motherchild_address2$cpf),
  collapse::fselect(address,
                    cpf, namea, year, idstreet, 
                    stdnumber, cep), # ALL POSSIBLE MATCHES
  by.x = c("mothernamea", "year", "idstreet",
           "stdnumber", "cep"),
  by.y = c("namea", "year", "idstreet",
           "stdnumber", "cep")) %>%
  # RENAME AND SELECT COLUMNS
  collapse::frename(cpf.x = cpf, cpf.y = mothercpf) %>%
  collapse::fselect(uf, cep, cpf, namea, gend,
                    dtbirth, mothernamea, mothercpf) %>%
  collapse::roworder(cpf) %>%
  collapse::funique()

# MERGE ATTEMPT 4: ADDRESS W/O NUMBER
motherchild_address4 <- data.table::merge.data.table(
  collapse::fsubset(address, # EXCLUDE CPFs LINKED IN MERGE 1
                    cpf %nin% motherchild_commonall$cpf &
                    cpf %nin% motherchild_address1$cpf &
                    cpf %nin% motherchild_address2$cpf &
                    cpf %nin% motherchild_address3$cpf),
  collapse::fselect(address,
                    cpf, namea, year, idstreet, cep), # ALL POSSIBLE MATCHES
  by.x = c("mothernamea", "year", "idstreet", "cep"),
  by.y = c("namea", "year", "idstreet", "cep")) %>%
  # RENAME AND SELECT COLUMNS
  collapse::frename(cpf.x = cpf, cpf.y = mothercpf) %>%
  collapse::fselect(uf, cep, cpf, namea, gend,
                    dtbirth, mothernamea, mothercpf) %>%
  collapse::roworder(cpf) %>%
  collapse::funique()

# MERGE ATTEMPT 5: ADDRESS ONLY CEP
motherchild_address5 <- data.table::merge.data.table(
  collapse::fsubset(address, # EXCLUDE CPFs LINKED IN MERGE 1
                    cpf %nin% motherchild_commonall$cpf &
                    cpf %nin% motherchild_address1$cpf &
                    cpf %nin% motherchild_address2$cpf &
                    cpf %nin% motherchild_address3$cpf &
                    cpf %nin% motherchild_address4$cpf),
  collapse::fselect(address,
                    cpf, namea, year, cep), # ALL POSSIBLE MATCHES
  by.x = c("mothernamea", "year", "cep"),
  by.y = c("namea", "year", "cep")) %>%
  # RENAME AND SELECT COLUMNS
  collapse::frename(cpf.x = cpf, cpf.y = mothercpf) %>%
  collapse::fselect(uf, cep, cpf, namea, gend,
                    dtbirth, mothernamea, mothercpf) %>%
  collapse::roworder(cpf) %>%
  collapse::funique()

# MERGE ATTEMPT 6: 7-DIGIT CEP
address <- address %>%
  collapse::ftransform(
    cep = stringr::str_sub(as.character(cep, 1, 7)))

motherchild_address6 <- data.table::merge.data.table(
  collapse::fsubset(address, # EXCLUDE CPFs LINKED IN MERGE 1
                    cpf %nin% motherchild_commonall$cpf &
                      cpf %nin% motherchild_address1$cpf &
                      cpf %nin% motherchild_address2$cpf &
                      cpf %nin% motherchild_address3$cpf &
                      cpf %nin% motherchild_address4$cpf &
                      cpf %nin% motherchild_address5$cpf),
  collapse::fselect(address,
                    cpf, namea, year, cep), # ALL POSSIBLE MATCHES
  by.x = c("mothernamea", "year", "cep"),
  by.y = c("namea", "year", "cep")) %>%
  # RENAME AND SELECT COLUMNS
  collapse::frename(cpf.x = cpf, cpf.y = mothercpf, uf.x = uf) %>%
  collapse::fselect(uf, cep, cpf, namea, gend,
                    dtbirth, mothernamea, mothercpf) %>%
  collapse::roworder(cpf) %>%
  collapse::funique()

# BIND ROWS ADDRESS' MERGE BATCH (1-6)
mother_child_address <- data.table::rbindlist(
  list(motherchild_address1, motherchild_address2,
       motherchild_address3, motherchild_address4,
       motherchild_address5, motherchild_address6))

rm(motherchild_address1, motherchild_address2,
   motherchild_address3, motherchild_address4,
   motherchild_address5, motherchild_address6)

# 3. REMOVE DUPLICATES ------------------------

# MOTHER DTBIRTH FROM RECEITA
mother_child_address <- data.table::merge.data.table(
  mother_child_address,
  collapse::fselect(receita,
                    cpf, dtbirth),
  by.x = "mothercpf",
  by.y = "cpf") %>%
  collapse::frename(dtbirth.x = dtbirth,
                    dtbirth.y = motherdtbirth) %>%
  collapse::fsubset(
    as.numeric(stringr::str_sub(motherdtbirth, 6, 9)) -
    as.numeric(stringr::str_sub(dtbirth, 6, 9)) %in%  c(10:50))

# MUN FROM ADDRESs
address <- readr::read_rds(paste0(path_receita, "A0_addresshist.rds")) %>%
  collapse::qDT() %>%
  collapse::fselect(cep, mun) %>%
  collapse::funique()

mother_child_address <- data.table::merge.data.table(
  mother_child_address,
  address,
  by = "cep") %>%
  collapse::fselect(-cep) %>%
  collapse::funique()

# SAVE TEMP FILE
write_rds(collapse::roworder(mother_child_address, cpf),
          here::here("data", "temp", "A2_motherchild_address.rds"),
          compress = "gz")

# END OF SCRIPT ----------------------------------------------