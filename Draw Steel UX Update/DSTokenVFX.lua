local mod = dmhub.GetModLoading()

TokenEffects.Register{
        id = "damage-acid",
        video = "md5:som6d/Ji13Qz4rXgr0zWXw==",
        duration = 1,
        playbackSpeed = 2,
        width = 180,
        height = 180,
        gradientMapping = true,
        gradient = gui.Gradient{
            point_a = {x = 0, y = 0},
            point_b = {x = 1, y = 0},
            stops = {
                {
                    position = 0,
                    color = "#0a4c25",
                },                
                {
                    position = 0.14,
                    color = "#837830",
                },
                {
                    position = 0.30,
                    color = "#89a15c",
                },                
                {
                    position = 0.60,
                    color = "#cff42f",
                },
                {
                    position = 0.80,
                    color = "#89a25e",
                },
                {
                    position = 1,
                    color = "#4e4e21",
                },
            },
        },
    }
TokenEffects.Register{
        id = "damage-cold",
        video = "md5:som6d/Ji13Qz4rXgr0zWXw==",
        duration = 1,
        playbackSpeed = 2,
        width = 180,
        height = 180,
        gradientMapping = true,
        gradient = gui.Gradient{
            point_a = {x = 0, y = 0},
            point_b = {x = 1, y = 0},
            stops = {
                {
                    position = 0,
                    color = "#3f92e8",
                },
                {
                    position = 0.30,
                    color = "#1a4e53",
                },                
                {
                    position = 0.34,
                    color = "#002136",
                },
                {
                    position = 0.74,
                    color = "#00ccff",
                },
                {
                    position = 1,
                    color = "#303941",
                },
            },
        },
    }

TokenEffects.Register{
        id = "damage-corruption",
        video = "md5:som6d/Ji13Qz4rXgr0zWXw==",
        duration = 1,
        playbackSpeed = 2,
        width = 180,
        height = 180,
        gradientMapping = true,
        gradient = gui.Gradient{
            point_a = {x = 0, y = 0},
            point_b = {x = 1, y = 0},
            stops = {
                {
                    position = 0,
                    color = "#282828",
                },
                {
                    position = 0.28,
                    color = "#e400f8",
                },                
                {
                    position = 0.59,
                    color = "#f8009e",
                },
                {
                    position = 0.8,
                    color = "#0b171c",
                },
            },
        },
    }

TokenEffects.Register{
        id = "damage-fire",
        video = "md5:som6d/Ji13Qz4rXgr0zWXw==",
        duration = 1,
        playbackSpeed = 2,
        width = 180,
        height = 180,
        gradientMapping = true,
        gradient = gui.Gradient{
            point_a = {x = 0, y = 0},
            point_b = {x = 1, y = 0},
            stops = {
                {
                    position = 0,
                    color = "#282828",
                },
                {
                    position = 0.38,
                    color = "#f83600",
                },
                {
                    position = 0.64,
                    color = "#f83600",
                },
                {
                    position = 1,
                    color = "#fff000",
                },
            },
        },
    }

TokenEffects.Register{
        id = "damage-holy",
        video = "md5:som6d/Ji13Qz4rXgr0zWXw==",
        duration = 1,
        playbackSpeed = 2,
        width = 180,
        height = 180,
        gradientMapping = true,
        gradient = gui.Gradient{
            point_a = {x = 0, y = 0},
            point_b = {x = 1, y = 0},
            stops = {
                {
                    position = 0,
                    color = "#581a09",
                },
                {
                    position = 0.21,
                    color = "#ffaf2e",
                }, 
                {
                    position = 0.47,
                    color = "#fcff96",
                }, 
                {
                    position = 0.52,
                    color = "#fcffff",
                },                
                {
                    position = 0.58,
                    color = "#fcff96",
                },
                {
                    position = 0.79,
                    --color = "#ffaf2e",
                    color = "#fdfdfd",

                },
                {
                    position = 0.96,
                    color = "#fdfdfd",
                },
            },
        },
    }    

TokenEffects.Register{
        id = "damage-lightning",
        video = "md5:som6d/Ji13Qz4rXgr0zWXw==",
        duration = 1,
        playbackSpeed = 2,
        width = 180,
        height = 180,
        gradientMapping = true,
        gradient = gui.Gradient{
            point_a = {x = 0, y = 0},
            point_b = {x = 1, y = 0},
            stops = {
                {
                    position = 0,
                    color = "#0024ff",
                },
                {
                    position = 0.26,
                    color = "#0024ff",
                }, 
                {
                    position = 0.33,
                    color = "#0090ff",
                }, 
                {
                    position = 0.45,
                    color = "#009cff",
                }, 
                {
                    position = 0.91,
                    color = "#ffffff",
                },                
            },
        },
    }   
    
TokenEffects.Register{
        id = "damage-poison",
        video = "md5:som6d/Ji13Qz4rXgr0zWXw==",
        duration = 1,
        playbackSpeed = 2,
        width = 180,
        height = 180,
        gradientMapping = true,
        gradient = gui.Gradient{
            point_a = {x = 0, y = 0},
            point_b = {x = 1, y = 0},
            stops = {
                {
                    position = 0,
                    color = "#0d1313",
                },
                {
                    position = 0.41,
                    color = "#00ff18",
                }, 
                {
                    position = 0.67,
                    color = "#84ff00",
                }, 
                {
                    position = 0.88,
                    color = "#13720f",
                }, 
                {
                    position = 0.91,
                    color = "#7cce1b",
                },                
            },
        },
    }        

TokenEffects.Register{
        id = "damage-psychic",
        video = "md5:som6d/Ji13Qz4rXgr0zWXw==",
        duration = 1,
        playbackSpeed = 2,
        width = 180,
        height = 180,
        gradientMapping = true,
        gradient = gui.Gradient{
            point_a = {x = 0, y = 0},
            point_b = {x = 1, y = 0},
            stops = {
                {
                    position = .24,
                    color = "#e75b62",
                },
                {
                    position = 0.45,
                    color = "#e990a9",
                },                
                {
                    position = 0.65,
                    color = "#f6adca",
                },
                {
                    position = 0.71,
                    color = "#f6adca",
                },
                {
                    position = 1,
                    color = "#faf2fa",
                },
            },
        },
    }    

    TokenEffects.Register{
        id = "damage-sonic",
        video = "md5:som6d/Ji13Qz4rXgr0zWXw==",
        duration = 1,
        playbackSpeed = 2,
        width = 180,
        height = 180,
        gradientMapping = true,
        gradient = gui.Gradient{
            point_a = {x = 0, y = 0},
            point_b = {x = 1, y = 0},
            stops = {
                {
                    position = .14,
                    color = "#0b171c",
                },
                {
                    position = 0.36,
                    color = "#21d3de",
                },                
                {
                    position = 0.47,
                    color = "#ffc0c0",
                },
                {
                    position = 0.59,
                    color = "#21d3de",
                },
                {
                    position = 0.8,
                    color = "#0b171c",
                },
            },
        },
    }    

