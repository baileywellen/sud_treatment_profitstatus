library(lme4)
#code to determine the best subset of demand variables to include 
demandvars_lrt <- function(df, demandvars_list, verbose = FALSE){
  
  model_list <- list()
  
  #loop through to peel off the last element from demandvars_list at a time, until only the first demand variable is left 
  for(i in 0:(length(demandvars_list)-1))
  {
    demand_variables_touse <- demandvars_list[1:(length(demandvars_list) - i)]
    
    #create the list of demand variables to use 
    demand_vars <- paste(demand_variables_touse, collapse = " + ")
    
    control_vars <- " + medicaid_enroll_percapita + 
             percapita_health_spending_thousands + 
             pop_millions +
             (1|State_Name) + (1 | year )"
    
    #paste the formula together 
    nb_formula <- formula(paste("count_tx ~", demand_vars, control_vars))
    
    #build the model and save in the list
    model <- glmer.nb(nb_formula, data = df, 
                      control = glmerControl(optimizer = "bobyqa", optCtrl = list(maxfun = 2e6)))
    
    #append the model to the list 
    model_list[[i + 1]] <- model
    
  }
  
  #store the maximum likelihood model - start by assuming it is the full model 
  max_model <- model_list[[1]]
  
  #compare the models pairwise using the LRT 
  for (i in seq(1:(length(model_list) - 1) ))
  {
    anova_results <- anova(max_model, model_list[[i+1]])
    
    if (verbose)
    {
      print("________________RESULTS_________________")
      print(anova_results)
    }
    
    #get the p-value
    pval <- anova_results$'Pr(>Chisq)'[2]
    
    if (pval < 0.05)
    {
      print(paste("The more complex model improves fit sufficiently, p = ", pval))
    }
    else
    {
      print(paste("The more complex model does not improve fit sufficiently. considering the less complex model to be better", p = pval))
      max_model <- model_list[[i+1]]
    }
    
    print("Best model so far includes: ")
    print(all.vars(formula(max_model)))
  }
}




#code to determine the best subset of demand variables to include 
controlvars_lrt <- function(df, bestdemandvars_str, controlvars_list, verbose = FALSE){
  
  model_list <- list()
  
  #loop through to peel off the last element from controlvars_list at a time, until only the first control variable is left 
  for(i in 0:(length(controlvars_list) - 1 ))
  {
    control_variables_touse <- controlvars_list[1:(length(controlvars_list) - i)]
    
    #create the list of control variables to use 
    control_vars <- paste(control_variables_touse, collapse = " + ")
    
    random_effects <- " +
             (1|State_Name) + (1 | year) "
    
    #paste the formula together 
    nb_formula <- formula(paste("count_tx ~", bestdemandvars_str, control_vars, random_effects))
    
    #build the model and save in the list
    model <- glmer.nb(nb_formula, data = df, 
                      control = glmerControl(optimizer = "bobyqa", optCtrl = list(maxfun = 2e6)))
    
    #append the model to the list 
    model_list[[i + 1]] <- model
    
  }
  
  
  #store the maximum likelihood model - start by assuming it is the full model 
  max_model <- model_list[[1]]
  
  #compare the models pairwise using the LRT 
  for (i in seq(1:(length(model_list) - 1) ))
  {
    anova_results <- anova(max_model, model_list[[i+1]])
    
    #get the p-value
    pval <- anova_results$'Pr(>Chisq)'[2]
    
    if (verbose)
    {
      print("________________RESULTS_________________")
      print(anova_results)
    }
    
    if (pval < 0.05)
    {
      print(paste("The more complex model improves fit sufficiently, p = ", pval))
    }
    else
    {
      print(paste("The more complex model does not improve fit sufficiently. considering the less complex model to be better", p = pval))
      max_model <- model_list[[i+1]]
    }
    
    print("Best model so far includes: ")
    print(all.vars(formula(max_model)))
  }
}




#demandvars_lrt(state_forprofit, c("prev2years_drugusecalc", "prev2years_aud", "prev2years_marijuana"), verbose = TRUE)
#controlvars_lrt(state_forprofit, "prev2years_drugusecalc + prev2years_aud + ", c("pop_millions",  "percapita_health_spending_thousands", "medicaid_enroll_percapita"), verbose = TRUE)

#demandvars_lrt(state_nonprofit, c("prev2years_drugusecalc", "prev2years_aud", "prev2years_marijuana"), verbose = TRUE)
#controlvars_lrt(state_nonprofit, "prev2years_drugusecalc + prev2years_aud + ", c("pop_millions", "medicaid_enroll_percapita", "percapita_health_spending_thousands"))

#demandvars_lrt(state_govt, c("prev2years_drugusecalc", "prev2years_aud", "prev2years_marijuana"))
#controlvars_lrt(state_govt, "prev2years_drugusecalc + prev2years_aud + ", c("pop_millions", "medicaid_enroll_percapita", "percapita_health_spending_thousands"))
