-- This threaded script is the main control script of the hexapod. It generates the body movement and controlls 
-- another script (non-threaded) that is in charge of generating the walking movement.
-- The other script is controlled via simulation parameters: this script writes the parameters (sim.setScriptSimulationParameter)
-- and the other script reads the parameters (sim.getScriptSimulationParameter).

setStepMode=function(stepVelocity,stepAmplitude,stepHeight,movementDirection,rotationMode,movementStrength)
    sim.setScriptSimulationParameter(sim.handle_tree,'stepVelocity',stepVelocity)
    sim.setScriptSimulationParameter(sim.handle_tree,'stepAmplitude',stepAmplitude)
    sim.setScriptSimulationParameter(sim.handle_tree,'stepHeight',stepHeight)
    sim.setScriptSimulationParameter(sim.handle_tree,'movementDirection',movementDirection)
    sim.setScriptSimulationParameter(sim.handle_tree,'rotationMode',rotationMode)
    sim.setScriptSimulationParameter(sim.handle_tree,'movementStrength',movementStrength)
end

moveBody=function(index)
    local p={initialP[1],initialP[2],initialP[3]}
    local o={initialO[1],initialO[2],initialO[3]}
    sim.moveToPosition(legBase,antBase,p,o,vel,accel)
    if (index==0) then
        -- up/down
        p[3]=p[3]-0.03*sizeFactor
        sim.moveToPosition(legBase,antBase,p,o,vel*2,accel)
        p[3]=p[3]+0.03*sizeFactor
        sim.moveToPosition(legBase,antBase,p,o,vel*2,accel)
    end
    if (index==1) then
        -- 4x twisting
        o[1]=o[1]+5*math.pi/180
        o[2]=o[2]-05*math.pi/180
        o[3]=o[3]-15*math.pi/180
        p[1]=p[1]-0.03*sizeFactor
        p[2]=p[2]+0.015*sizeFactor
        sim.moveToPosition(legBase,antBase,p,o,vel,accel)
        o[1]=o[1]-10*math.pi/180
        o[3]=o[3]+30*math.pi/180
        p[2]=p[2]-0.04*sizeFactor
        sim.moveToPosition(legBase,antBase,p,o,vel,accel)
        o[1]=o[1]+10*math.pi/180
        o[2]=o[2]+10*math.pi/180
        p[2]=p[2]+0.03*sizeFactor
        p[1]=p[1]+0.06*sizeFactor
        sim.moveToPosition(legBase,antBase,p,o,vel,accel)
        o[1]=o[1]-10*math.pi/180
        o[3]=o[3]-30*math.pi/180
        p[2]=p[2]-0.03*sizeFactor
        sim.moveToPosition(legBase,antBase,p,o,vel,accel)
    end
    if (index==2) then
        -- rolling
        p[3]=p[3]-0.0*sizeFactor
        o[1]=o[1]+17*math.pi/180
        sim.moveToPosition(legBase,antBase,p,o,vel,accel)
        o[1]=o[1]-34*math.pi/180
        sim.moveToPosition(legBase,antBase,p,o,vel,accel)
        o[1]=o[1]+17*math.pi/180
        p[3]=p[3]+0.0*sizeFactor
        sim.moveToPosition(legBase,antBase,p,o,vel,accel)
    end
    if (index==3) then
        -- pitching
        p[3]=p[3]-0.0*sizeFactor
        o[2]=o[2]+15*math.pi/180
        sim.moveToPosition(legBase,antBase,p,o,vel,accel)
        o[2]=o[2]-30*math.pi/180
        sim.moveToPosition(legBase,antBase,p,o,vel,accel)
        o[2]=o[2]+15*math.pi/180
        p[3]=p[3]+0.0*sizeFactor
        sim.moveToPosition(legBase,antBase,p,o,vel,accel)
    end
    if (index==4) then
        -- yawing
        p[3]=p[3]+0.0*sizeFactor
        o[3]=o[3]+30*math.pi/180
        sim.moveToPosition(legBase,antBase,p,o,vel,accel)
        o[3]=o[3]-60*math.pi/180
        sim.moveToPosition(legBase,antBase,p,o,vel,accel)
        o[3]=o[3]+30*math.pi/180
        sim.moveToPosition(legBase,antBase,p,o,vel,accel)
        p[3]=p[3]-0.0*sizeFactor
        sim.moveToPosition(legBase,antBase,p,o,vel,accel)
    end
end

function sysCall_threadmain()
    antBase=sim.getObjectHandle('hexa_base')
    legBase=sim.getObjectHandle('hexa_legBase')
    sizeFactor=sim.getObjectSizeFactor(antBase)
    vel=0.05
    accel=0.05
    initialP={0,0,0}
    initialO={0,0,0}
    initialP[3]=initialP[3]-0.03*sizeFactor
    sim.moveToPosition(legBase,antBase,initialP,initialO,vel,accel)

    stepHeight=0.02*sizeFactor
    maxWalkingStepSize=0.11*sizeFactor
    walkingVel=0.9

    -- On the spot movement:
    setStepMode(walkingVel,maxWalkingStepSize,stepHeight,0,0,0)
    moveBody(0)
    moveBody(1)
    moveBody(2)
    moveBody(3)
    moveBody(4)

    -- Forward walk while keeping a fixed body posture:
    setStepMode(walkingVel,maxWalkingStepSize,stepHeight,0,0,1)
    sim.wait(12)
    for i=1,27,1 do
        setStepMode(walkingVel,maxWalkingStepSize,stepHeight,10*i,0,1)
        sim.wait(0.5)
    end
    -- Stop:
    setStepMode(walkingVel,maxWalkingStepSize,stepHeight,270,0,0)
    sim.wait(2)

    -- Forward walk while changing the body posture:
    setStepMode(walkingVel,maxWalkingStepSize*0.5,stepHeight,0,0,1)
    moveBody(0)
    moveBody(1)
    moveBody(2)
    moveBody(3)
    moveBody(4)
    -- Stop:
    setStepMode(walkingVel,maxWalkingStepSize*0.5,stepHeight,0,0,0)
    sim.wait(2)

    -- Rotate on the spot:
    setStepMode(walkingVel,maxWalkingStepSize*0.5,stepHeight,0,1,1)
    sim.wait(24)
    -- Stop:
    setStepMode(walkingVel,maxWalkingStepSize*0.5,stepHeight,0,0,0)
end

