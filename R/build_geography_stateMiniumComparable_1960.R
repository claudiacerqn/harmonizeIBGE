#' Builds a synthetic variable for education attainment - 2010
#' @param data.frame
#' @value data.frame
#' @export

build_geography_stateMiniumComparable_1960 <- function(CensusData){
        
        if(!is.data.frame(CensusData)){
                stop("'CensusData' is not a data.frame")
        }
        
        if(!is.data.table(CensusData)){
                CensusData = as.data.table(CensusData)
        }
        
        stateCurrent_just_created = F
        check_vars <- harmonizeIBGE:::check_var_existence(CensusData, c("stateCurrent"))
        if(length(check_vars) > 0){
                CensusData <- build_geography_stateCurrent_1960(CensusData)
                stateCurrent_just_created = T
                gc()
        }
        
        data("crosswalk_states_tmp")
        
        crosswalk_states_tmp <- crosswalk_states_tmp %>%
                filter(year == 1960 & variable == "state") %>%
                select(original_code, semi_harmonized_code) %>%
                rename(stateCurrent          = original_code,
                       stateMiniumComparable = semi_harmonized_code)
        
        CensusData <- data.table:::merge.data.table(x = CensusData,
                                                    y = crosswalk_states_tmp,
                                                    by = "stateCurrent", 
                                                    all.x = T, 
                                                    all.y = F, 
                                                    sort = F)
        
        gc()
        
        if(stateCurrent_just_created == TRUE){
                CensusData[ , stateCurrent := NULL]
        }
        
        
        gc()
        CensusData
}