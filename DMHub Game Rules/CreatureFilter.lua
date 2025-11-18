local mod = dmhub.GetModLoading()

CreatureFilter = {

    Register = function(args)
        local filters = CreatureFilter.filters
        local filterOptions = CreatureFilter.filterOptions
        filters[args.id] = args
        
        local index = #filterOptions + 1
        for i,filter in ipairs(filterOptions) do
            if filter.id == args.id then
                index = i
                break
            end
        end

        filterOptions[index] = args
    end,

    filters = {},

    filterOptions = {},
}