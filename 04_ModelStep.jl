function model_step!(model)
    model.tick += 1                                            # represents time marker
    model.P_hyd = Binomial(1,model.p_hyd)                      # Prob to hydrolize from GTP to GDP: 
    model.P_polym = Binomial(1,model.p_polym)                  # Prob to Polymerize/bind to the microtubule 
    model.P_depolym_GTP = Binomial(1,model.p_depolym_GTP)      # Prob to depolimerize if not hydrolized (GTP - tubulin) = lower
    model.P_depolym_GDP = Binomial(1,model.p_depolym_GDP)      # Prob to depolimerize if hydrolized (GDP - tubulin) = higher
    model.P_GTP_exchange = Binomial(1,model.p_GTP_exchange)    # Prob to exchange GDP to GTP
end