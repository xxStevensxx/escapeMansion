local const = {

    -- Types de personnages ou entités du jeu
    TYPE = {
        
        ARMORED_SKELETON = "armored_skeleton",
        ORC = "orc",
        ORC_RIDER= "orc_rider",
        SOLDIER = "soldier",
    },

    -- Maps disponibles dans le jeu
    MAP = {
        MANSION = "mansion",
    },

    -- Chemins vers les images (sprites) utilisées dans le jeu
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
        PANEL_ONE = love.graphics.newImage("/assets/images/panel2.png"),
    },


    -- États possibles d’un personnage
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

    -- États globaux du jeu (menus, phases)
    GAME_STATE = {

        STARTED = "started",
        PLAY = "play",
        PAUSE = "pause",
        RESTART = "restart",
        QUIT = "quit",
        GAMEOVER = "gameover",

    },

    -- Types d’animation des personnages
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

    -- Cibles possibles (actuellement une seule valeur)
    TARGET = {

        NONE = "none",
    },

    -- Sons utilisés dans le jeu
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


    -- Objets du jeu (armes)
    OBJECT = {
        BOW = "bow",
        ARROW = "arrow",
        SWORD = "sword",
    },


    -- Textes affichés dans le jeu (ex : tutoriels, options de menu)
    TEXT = {

        TUTO_TEXT = "Bienvenue dans une Version Pre-Alpha de Mansion Escape appuyez sur une touche pour demmarrer",
        TUTO = {"Touche E = ramasser", "Touche A = Epée", "touche B = Arc", "Touche ESC = quitter", "Touche F1 = debug", "Appuyer sur une touche pour commencer"},
        PAUSE_OPTIONS = {"Reprendre", "Quitter"},
        STARTED_OPTIONS = {"Start"},

        -- Alignements pour le texte (seulement center pour l’instant)
        ALIGN = {

            CENTER = "center",
            -- d’autres comme left, right peuvent être ajoutés ici
        },
    },

    -- Polices utilisées dans le jeu
    FONT = {

        KEN = love.graphics.newFont("assets/font/kenvector_future_thin.ttf")
        
    },


    GROUP = {
        startedGroup = "startedGroup",
        pauseGroup = "pauseGroup",
        restartGroup = "restartGroup",
        quitGroup = "quitGroup",
        gameoverGroup = "gameoverGroup",
        playGroup = "playGroup",
    },


}

return const
