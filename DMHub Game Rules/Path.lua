local mod = dmhub.GetModLoading()

GameSystem.RegisterGoblinScriptField{
    target = PathMoved,
    name = "squares",
    type = "number",
    desc = "The number of squares moved.",
    calculate = function(c)
        return c.path.numSteps
    end,
}
