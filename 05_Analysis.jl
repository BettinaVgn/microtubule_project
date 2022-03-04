function mean_MT_size(model)
    meanMTL = mean([count(i->(i==n), [model.agents[i].polym for i in 1:length(model.agents)]) for n in 1:model.Nstarts])
end

function sd_MT_size(model)
    stdMTL = std([count(i->(i==n), [model.agents[i].polym for i in 1:length(model.agents)]) for n in 1:model.Nstarts])
end

function free_tubulin(model)
    freetub = count(i->(i == 0), [model.agents[i].polym for i in 1:length(model.agents)])
end

function polym_tubulin(model)
    polym_tub = count(i->(i > 0), [model.agents[i].polym for i in 1:length(model.agents)])
end

function MT_size_each(model)
    MT_size_each = Int64[]
    for x in 1:model.Nstarts
        push!(MT_size_each,count(i->(i==x), [model.agents[i].polym for i in 1:length(model.agents)]))
    end
    return MT_size_each
end

function growth_classification!(df; section_size = 200)
    df.growthrate = zeros(nrow(df))
    for n in 2:nrow(df)
        if df.step[n] == 0
            df.growthrate[n]=0
        elseif df.step[n]>0
            df.growthrate[n]= df[n,:mean_MT_size]-df[n-1,:mean_MT_size]
        end
    end

    df.growthclass = [0 for i in 1:nrow(df)]
    for i in collect(1:section_size:maximum(df.step)-section_size+1)
        section = collect(i:i+section_size-1)
        count_plus = count(x -> (x == 1.0), df.growthrate[section])
        count_minus = count(x -> (x == -1.0), df.growthrate[section])
        growthclass = count_minus >= 0.08*section_size ? -1.0 : count_plus >= 0.012*section_size ? 1.0 : 0.0

        for n in section
            df.growthclass[n] = growthclass
        end
    end

    df.growthclass_group = [1 for i in 1:nrow(df)]
    for (i,v) in enumerate(df.growthclass)
        if i == 1
            continue
        elseif v == df.growthclass[i-1]
            df.growthclass_group[i] = df.growthclass_group[i-1]
        else
            df.growthclass_group[i] = df.growthclass_group[i-1] + 1
        end
    end
    return df
end

function velocity(df)
    df_new = DataFrame(growthclass_group = [i for i in 1:maximum(df.growthclass_group)], velocity = zeros(maximum(df.growthclass_group)))

    for i in 1:maximum(df.growthclass_group)
        sub_df = @subset(df, :growthclass_group .== i)
        step_min = minimum(sub_df.step)
        step_max = maximum(sub_df.step)
        MT_min = minimum(sub_df.mean_MT_size)
        MT_max = maximum(sub_df.mean_MT_size)

        if sub_df.growthclass[1] == 1.0
            df_new.velocity[i] = (MT_max-MT_min)/(step_max - step_min)
        elseif sub_df.growthclass[1] == -1.0
            df_new.velocity[i] = (MT_min-MT_max)/(step_max - step_min)
        else
            df_new.velocity[i] = 0
        end   
    end
    return df_new
end

function mean_velocity_grow(df)
    grow_velocities = [df.velocity[i] for i in 1:nrow(df) if df.velocity[i] > 0]
    if isempty(grow_velocities)
        mean_velocity_grow = 0
    else
        mean_velocity_grow = mean(grow_velocities)
    end
end

function mean_velocity_cat(df)
    cat_velocities = [df.velocity[i] for i in 1:nrow(df) if df.velocity[i] < 0]
    if isempty(cat_velocities)
        mean_velocity_cat = 0
    else
        mean_velocity_cat = mean(cat_velocities)
    end
end