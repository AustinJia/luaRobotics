function speedChange_callback(ui,id,newVal)
    speed=minMaxSpeed[1]+(minMaxSpeed[2]-minMaxSpeed[1])*newVal/100
end

function sysCall_init()
    -- This is executed exactly once, the first time this script is executed
    bubbleRobBase2=sim.getObjectAssociatedWithScript(sim.handle_self) -- this is bubbleRob's handle
    leftMotor=sim.getObjectHandle("cylinder2_motor1") -- Handle of the left motor
    rightMotor=sim.getObjectHandle("cylinder2_motor2") -- Handle of the right motor
    backMotor=sim.getObjectHandle("cylinder2_motor3") -- Handle of the right motor
    noseSensorFront=sim.getObjectHandle("proximity_sensor2_1") -- Handle of the proximity sensor
    noseSensorBack=sim.getObjectHandle("proximity_sensor2_2") -- Handle of the proximity sensor
    minMaxSpeed={50*math.pi/180,300*math.pi/180} -- Min and max speeds for each motor
    mode = 1
    switch = 1
    backUntilTime=-1 -- Tells whether bubbleRob is in forward or backward mode
    -- Create the custom UI:
        xml = '<ui title="'..sim.getObjectName(bubbleRobBase2)..' speed" closeable="false" resizeable="false" activate="false">'..[[
        <hslider minimum="0" maximum="100" onchange="speedChange_callback" id="1"/>
        <label text="" style="* {margin-left: 300px;}"/>
        </ui>
        ]]
    ui=simUI.create(xml)
    speed=(minMaxSpeed[1]+minMaxSpeed[2])*0.5
    simUI.setSliderValue(ui,1,100*(speed-minMaxSpeed[1])/(minMaxSpeed[2]-minMaxSpeed[1]))
end

function sysCall_actuation()
    resultFront=sim.readProximitySensor(noseSensorFront) -- Read the proximity sensor
    resultBack=sim.readProximitySensor(noseSensorBack) -- Read the proximity sensor
    -- If we detected something, we set the backward mode:
    -- if nothing detect then go forward
    if (switch ==1 and resultFront<=0) then 
        mode = 1
    else
        switch = 2
    end

    if (switch ==2 and resultBack<=0) then 
        mode = 2
    else
        switch = 1
    end

    if (mode==1) then
        -- When in forward mode, we simply move forward at the desired speed
        sim.setJointTargetVelocity(leftMotor,speed)
        sim.setJointTargetVelocity(rightMotor,speed)
        sim.setJointTargetVelocity(backMotor,speed)
    else
        -- When in backward mode, we simply backup in a curve at reduced speed
        sim.setJointTargetVelocity(leftMotor,-speed)
        sim.setJointTargetVelocity(rightMotor,-speed)
        sim.setJointTargetVelocity(backMotor,-speed)
    end
    print(mode,switch,resultFront,resultBack)
    --sim.auxiliaryConsolePrint(bubbleRob,"good!!!!!!!!!!!!!!!!!")
end

function sysCall_cleanup()
	simUI.destroy(ui)
end