local const = {

    --TYPE
    TYPE = {
        
        ARMORED_SKELETON = "armored_skeleton",
        ORC = "orc",
        ORC_RIDER= "orc_rider",
        SOLDIER = "soldier",
    },

    -- MAP
    MAP = {
        MANSION = "mansion",
    },

    --IMAGE PATH`
    SPRITE = {

        ORC = love.graphics.newImage("assets/images/Orc.png"),
        ORC_RIDER = love.graphics.newImage("assets/images/Orc rider.png"),
        SOLDIER = love.graphics.newImage("assets/images/Soldier.png"),
        ARMORED_SKELETON = love.graphics.newImage("assets/images/Armored Skeleton.png"),
        LEFT_HEART = love.graphics.newImage("assets/images/leftHeart.png"),
        RIGHT_HEART = love.graphics.newImage("assets/images/rightHeart.png"),
        BOW = love.graphics.newImage("assets/images/bow.png"),
        ARROW = love.graphics.newImage("assets/images/Arrow.png"),
        SWORD = love.graphics.newImage("assets/images/sword.png"),
        MANSION = love.graphics.newImage("assets/images/Dungeon_Tileset.png"),
    },


    --STATES 
    STATE = {

        NONE = "none",
        IDLE = "idle",
        WALK = "walk",
        ATTACK = "attack",
        SUPER_ATTACK = "super_attack",
        GUARD = "guard",
        DASH = "dash",
        DAMMAGE = "dammage",
        DEAD = "dead",
        CHANGEDIR = "change_dir",
        PURSUIT = "pursuit",
        SEARCH = "search"

    },

    -- GAME STATE
    GAME_STATE = {

        STARTED = "started",
        PLAY = "play",
        PAUSE = "pause",
        RESTART = "restart",
        QUIT = "quit",
        GAMEOVER = "gameover",

    },

    -- animation
    ANIM = {

        IDLE = "idle",
        WALK = "walk",
        ATTACK_ONE = "attack_one",
        ATTACK_TWO = "attack_two",
        ATTACK_THREE = "attack_three",
        GUARD = "guard",
        DASH = "dash",
        DAMMAGE = "dammage",
        DEAD = "death",

    },

    --target
    TARGET = {

        NONE = "none",
    },

    -- sound
    SOUND = {
        DAMMAGE_THREE = love.audio.newSource("assets/sounds/Damage3.wav", "static"),
        DAMMAGE_FOUR = love.audio.newSource("assets/sounds/Damage4.wav", "static"),
        DAMMAGE_FIVE = love.audio.newSource("assets/sounds/Damage5.wav", "static"),
        SLASH_ONE = love.audio.newSource("assets/sounds/Slash1.wav", "static"),
        SWORD_FOUR = love.audio.newSource("assets/sounds/Sword4.wav", "static"),
        EQUIP = love.audio.newSource("assets/sounds/Equip.wav", "static"),
        BOW_SHOOT = love.audio.newSource("assets/sounds/Crossbow.wav", "static"),
        MUSIC = love.audio.newSource("assets/sounds/Tunnel.wav", "stream"),
    },


    --OBJECT
    OBJECT = {
        BOW = "bow",
        ARROW = "arrow",
        SWORD = "sword",
    },



    TEXT = {

        TUTO_TEXT = "Bienvenue dans une Version Pre-Alpha de Mansion Escape appuyez sur une touche pour demmarrer",
        TUTO = {"Touche E = ramasser", "Touche A = Epée", "touche B = Arc", "Touche ESC = quitter", "Touche F1 = debug", "Appuyer sur une touche pour commencer"},
        PAUSE_OPTIONS = {"Reprendre", "Quitter"},
        STARTED_OPTIONS = {"Start"},

        ALIGN = {

            CENTER = "center",
            --left right ect...
        },
    },


    FONT = {

        KEN = love.graphics.newFont("assets/font/kenvector_future_thin.ttf")
        
    }


}

return const
