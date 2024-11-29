local powerups = {}

-- Speed
powerups.speed = {
    speed = 10,
    type = "powerup",
    object = "speed",
    sprite = love.graphics.newImage("Graphics/Powerups/speedPower.png"),
    soundEffect = love.audio.newSource("SoundEffects/speed.wav", "static"),
    width = 11,
    height = 11,
}

return powerups