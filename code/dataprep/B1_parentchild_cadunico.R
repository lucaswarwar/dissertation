# > PROJECT INFO
# NAME: INTERGENERATIONAL MOBILITY IN BRAZIL
# LEAD: LUCAS WARWAR
#
# > THIS SCRIPT
# AIM: LINK FAMILIES - PHASE II - CADUNICO
# AUTHOR: LUCAS WARWAR
#
# > NOTES
# B1: - LINK PARENT-CHILD USING CADUNICO'S DATA

# SETUP -----------------------------------------------

source("code/fun/setup.R")

# LOAD ALL CADUNICO'S YEARS DATA -------------------

read_cadunico <- function(year) {

    cadunico <- haven::read_dta(
        paste0(path_cadunico, year, "/cadunico", year, "base.dta")) %>%
    collapse::qDT() %>%
    collapse::fselect(codfamiliarfam, nummembrofmla, nompessoa,
                      codsexopessoa, race, dtanascpessoa, mun,
                      codparentescorfpessoa, nomcompletomaepessoa,
                      nomcompletopaipessoa, numcpfpessoa) %>%
    collapse::frename(nompessoa = namea,
                      codsexopessoa = gend,
                      nummembrofmla = numembfam,
                      codfamiliarfam = cdfam,
                      codparentescorfpessoa = cdparentrf,
                      dtanascpessoa = dtbirth,
                      nomcompletomaepessoa = mothernamea,
                      nomcompletopaipessoa = fathernamea,
                      numcpfpessoa = cpf) %>%
    collapse::roworder(cdfam)

    return(cadunico)

}

cadunico <- purrr::map(c(2011:2020), read_cadunico) %>%
    data.table::rbindlist() %>%
    collapse::funique()

# 1.) LINK PARENT-CHILD FROM HOUSEHOLD ------------------------

# MERGE 1: MOTHER-CHILD
motherchild_cad_hh <- data.table::merge.data.table(
    cadunico,
    collapse::fselect(cadunico, namea, cpf),
    by.x = c("cdfam", "mothernamea"),
    by.y = c("cdfam", "namea")) %>%
    collapse::frename(cpf.x = cpf, cpf.y = mothercpf) %>%
    collapse::fselect(cdfam, cpf, numembfam, cdparentrf,
                      gend, race, dtbirth, mun, mothernamea,
                      fathernamea, mothercpf) %>%
    collapse::roworder(cpf)

# MERGE 2: FATHER-CHILD
motherchild_cad_hh <- data.table::merge.data.table(
    cadunico,
    collapse::fselect(cadunico, namea, cpf),
    by.x = c("cdfam", "fathernamea"),
    by.y = c("cdfam", "namea")) %>%
    collapse::frename(cpf.x = cpf, cpf.y = fathercpf) %>%
    collapse::fselect(cdfam, cpf, numembfam, cdparentrf,
                      gend, race, dtbirth, mun, mothernamea,
                      fathernamea, fathercpf) %>%
    collapse::roworder(cpf)