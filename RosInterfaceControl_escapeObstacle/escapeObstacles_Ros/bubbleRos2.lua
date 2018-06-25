function sysCall_init()
        
    robotHandle=sim.getObjectAssociatedWithScript(sim.handle_self)
    leftMotor=sim.getObjectHandle("bubbleRob_leftMotor2") -- Handle of the left motor
    rightMotor=sim.getObjectHandle("bubbleRob_rightMotor2") -- Handle of the right motor
    noseSensor=sim.getObjectHandle("bubbleRob_sensingNose2") -- Handle of the pro sensor
    -- Check if the required ROS plugin is there:
    moduleName=0
    moduleVersion=0
    index=0
    pluginNotFound=true
    while moduleName do
        moduleName,moduleVersion=sim.getModuleName(index)
        if (moduleName=='RosInterface') then
            pluginNotFound=false
        end
        index=index+1
    end
    -- Ok now launch the ROS client application:
    if (not pluginNotFound) then
        local sysTime=sim.getSystemTimeInMs(-1) 
        local leftMotorTopicName='leftMotorSpeed'..sysTime
        local rightMotorTopicName='rightMotorSpeed'..sysTime
        local sensorTopicName='sensorTrigger'..sysTime
        local simulationTimeTopicName='simTime'..sysTime
        -- Prepare the sensor publisher and the motor speed subscribers:
        sensorPub=simROS.advertise('/'..sensorTopicName,'std_msgs/Bool')
        simTimePub=simROS.advertise('/'..simulationTimeTopicName,'std_msgs/Float32')
        leftMotorSub=simROS.subscribe('/'..leftMotorTopicName,'std_msgs/Float32','setLeftMotorVelocity_cb')
        rightMotorSub=simROS.subscribe('/'..rightMotorTopicName,'std_msgs/Float32','setRightMotorVelocity_cb')
        -- Now we start the client application:
        result=sim.launchExecutable('rosBubbleRob2',leftMotorTopicName.." "..rightMotorTopicName.." "..sensorTopicName.." "..simulationTimeTopicName,0)
    end
    
end
function setLeftMotorVelocity_cb(msg)
    -- Left motor speed subscriber callback
    sim.setJointTargetVelocity(leftMotor,msg.data)
end

function setRightMotorVelocity_cb(msg)
    -- Right motor speed subscriber callback
    sim.setJointTargetVelocity(rightMotor,msg.data)
end

function getTransformStamped(objHandle,name,relTo,relToName)
    --{header={stamp=timeStamp, frame_id='...'}, child_frame_id='...',
    -- transform={translation={x=..., y=..., z=...}, rotation={x=..., y=..., z=..., w=...}}}
    t=sim.getSystemTime()
    p=sim.getObjectPosition(objHandle,relTo)--ssim.getObjectPosition(number objectHandle,number relativeToObjectHandle)
    o=sim.getObjectQuaternion(objHandle,relTo)--sim.getObjectQuaternion(number objectHandle,number relativeToObjectHandle)

    return{
        header={
            stamp=t,
            frame_id=relToName
        },
        child_fram_id=name,
        transfrom={
            translation={x=p[1],y=p[2],z=p[3]},
            rotation={x=o[1],y=o[2],z=o[3],w=o[4]}
        }
    }

end


function sysCall_actuation()
    -- Send an updated sensor and simulation time message, and send the transform of the robot:
    if not pluginNotFound then
        local result=sim.readProximitySensor(noseSensor)
        local detectionTrigger={}
        detectionTrigger['data']=result>0
        -- simROS.publish(int publisherHandle, table message)
        simROS.publish(sensorPub,detectionTrigger)
        simROS.publish(simTimePub,{data=sim.getSimulationTime()})

        -- Send the robot's transform:
        simROS.sendTransform(getTransformStamped(robotHandle,'bubbleRos2',-1,'world'))
        -- To send several transforms at once, use simROS.sendTransforms instead
    end
end

function sysCall_cleanup()
    if not pluginNotFound then
        -- Following not really needed in a simulation script (i.e. automatically shut down at simulation end):
        simROS.shutdownPublisher(sensorPub)
        simROS.shutdownSubscriber(leftMotorSub)
        simROS.shutdownSubscriber(rightMotorSub)
    end
end
