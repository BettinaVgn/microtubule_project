function agent_step!(agent,model)
# for all free agents (which are not the starting points in the beginning)
    if agent.id > model.Nstarts && agent.polym == 0           # only agents that are not starting points and are not yet polymerized    

        walk!(agent, rand, model, ifempty = true)             # agent walks +/-1 Position in random direction but only if this location is empty
        
        if agent.GDP 
            agent.GDP = rand(model.P_GTP_exchange) == 1 ? false : true #if GDP is bound, it is decided if it will be eschanged to GTP
        end
        
        for id in nearby_ids(agent, model, 1)                # for all other agents right next to agent (r = 1 is the distance)
            if model[id].polym > 0  && model[id].pos == collect(nearby_positions(agent, model,1))[8]  # if agent at the upper right corner ([8]) is polymerized
                agent.polym = rand(model.P_polym) == 1 ? model[id].polym : 0 
                # if rand() == 1 then the agent receives the MT id of neighbor[8] otherwise it stays at 0 (agents is still not polymerized)
            end
        end
    end
    
# for all polymerized agents (which are not the starting points):
    if agent.polym > 0 && agent.id > model.Nstarts            
        if agent.GDP == false                   # if GTP is bound               
            agent.GDP = rand(model.P_hyd)       # GTP gets hydrolyzed with the probability of p_hyd 
            # rand(...) results in either 1 or 0 which can also be interpreted as true or false  
        end
        
        if isempty(collect(nearby_positions(agent, model,1))[1], model)           # checks if nearby position at lower left corner ([1]) is empty
            if agent.GDP                                                          # if GDP is bound
                agent.polym = rand(model.P_depolym_GDP) == 1  ? 0 : agent.polym   
                # if rand(...) == 1 the agent depolymerizes (agent.polym = 0), else the agent.polym stays the same
            else                                                                  # if GTP is bound
                agent.polym = rand(model.P_depolym_GTP) == 1  ? 0 : agent.polym   
                # if rand(...) == 1 the agent depolymerizes (agent.polym = 0), else the agent.polym stays the same
            end
        end
   end
end