function initialize(;Nstarts::Int64, numagents::Int64, periodic::Bool, griddims::Tuple{Int64,Int64}, p_hyd::Float64,  p_polym::Float64,
    p_depolym_GTP::Float64, p_depolym_GDP::Float64, p_GTP_exchange::Float64)

    P_hyd = Binomial(1,p_hyd)                       # Prob to hydrolize from GTP to GDP:  GTPase rate
    P_polym = Binomial(1,p_polym)                   # Prob to Polymerize/bind to the microtuble 
    P_depolym_GTP = Binomial(1,p_depolym_GTP)       # Prob to depolimerize if not hydrolized (GTP - tubulin) = lower
    P_depolym_GDP = Binomial(1,p_depolym_GDP)       # Prob to depolimerize if hydrolized (GDP - tubulin) = higher
    P_GTP_exchange = Binomial(1,p_GTP_exchange)     # Prob to exchange GDP to GTP

    properties = @dict griddims numagents Nstarts p_depolym_GTP p_depolym_GDP p_polym p_hyd p_GTP_exchange P_hyd P_polym P_depolym_GTP P_depolym_GDP P_GTP_exchange

    properties[:tick] = 0

    space = GridSpace(griddims, periodic = periodic )   # define Gridspace with dimensions and if periodic = true or false

    model = ABM(tubulin, space;             # create model using Agents.ABM function
    scheduler = Schedulers.randomly,        # activates all agents once per step in a random order
    properties = properties )               # all parameters are given to the model as properties, so they can be consequently be accessed and used in later steps
    
    for i in 1:Nstarts                      # populating Grid Space with Startingpoints
    agent =  tubulin(i,(1,1),i,true)        # first agent with id = 1, positioned at (1,1), microtubulus id = 1, hydrolized status = true and so on
    add_agent_single!(agent, model)         # add this agent at random location
    end  

    for i in Nstarts+1:numagents            # populating Grid Space with rest of Agents (free tubulin)
    agent =  tubulin(i,(1,1),0,false)       # rest of agents are unpolymerized (polym=0) and not hydrolized (GDP = false)
    add_agent_single!(agent, model)         # add agents to random positions
    end

    return model
end