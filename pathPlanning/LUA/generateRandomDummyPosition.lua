--lua 5.3

--define Function
--function _generateRandomPosition()
    --a =
--end


function _insertStuff (tableTemp,key,value)
  tableTemp[key] = value
end

function _printTable(count,tableTemp)
  for i = 1,count do print(t[i]) end
end


--leg1........leg2
--................
--................
--................
--...............
--leg3........leg4


--the robot will follow the Y axis to walk
--the leg 1 and leg3 will be position will be                    (0,0.5,0)          (0,1,0)          (0,1.5,0)          (0,2,0)          (0,2.5,0)
--                                                   (0.2,0.25,0)       (0.2,0.75,0)       (0.2,1.25,0)    (0.2,1.75,0)        (0.2,2.25,0)
--the leg 2 and leg4 will be position will be                    (2,0.5,0)          (2,1,0)          (2,1.5,0)          (2,2,0)          (2,2.5,0)
--                                                   (2.2,0.25,0)       (2.2,0.75,0)       (2.2,1.25,0)    (2.2,1.75,0)        (2.2,2.25,0)

--Step 1: create a base dummy
baseDummyHandle = sim.createDummy(0.01,nil)
sim.setObjectName(baseDummyHandle,"baseDummy")


-- Step 2: simulate for leg 1 and leg 3
-- Step 2.1: create dummy Handle Table:
dummyHandles13 = {}
dummyPositions13 = {{0.2,0.25,0},{0,0.5,0},{0.2,0.75,0},{0,1,0},{0.2,1.25,0},{0,1.5,0},{0.2,1.75,0},{0,2,0},{0.2,2.25,0},{0,2.5,0}}



-- Step 3: simulate for leg 2 and leg 4
dummyHandles24 = {}
dummyPositions24 = {{2.2,0.25,0},{2,0.5,0},{2.2,0.75,0},{2,1,0},{2.2,1.25,0},{2,1.5,0},{2.2,1.75,0},{2,2,0},{2.2,2.25,0},{2,2.5,0}}





-- Step 4.1: Create a proximity sensor with range of 100
function sysCall_init()

    options = 1
    intParam = {0,0,0,0,0,0,0,0}
    floatParam = {0,5,0,0,0,0,0,0,0,0,0,0,0,0,0}
    color = nil
    proxSens = sim.createProximitySensor(sim.proximitysensor_ray_subtype, sim.objectspecialproperty_detectable_laser, options, intParam, floatParam, color)

end

-- Step 4.2: set the position of promity sensor
sim.setObjectName(proxSens,"pro_sensor_test_V1")
pro_sensor_test_V1_handle = sim.getObjectHandle("pro_sensor_test_V1")

--result,data=sim.handleProximitySensor(proxSens_1)
--sim.getObjectOrientation(proxSens,baseDummyHandle)
sim.setObjectOrientation(pro_sensor_test_V1_handle,baseDummyHandle,{-math.pi,0,0})

-- Step 4.3: Change the position of the promity sensor
count = 10
Height = 3
for i = 1,count do
    if sim.setObjectPosition(pro_sensor_test_V1_handle,baseDummyHandle,{dummyPositions13[i][1],dummyPositions13[i][2],Height}) == 1 then
        result,data=sim.handleProximitySensor(pro_sensor_test_V1_handle)
    else
        result = -1
    end
    if result == 1 then
        dummyPositions13[i]={dummyPositions13[i][1],dummyPositions13[i][2],Height-data }
    end
end

-- Step 5: generate position for dummy object(create object -> objectHandle -> )
count = 10
--for i = 1,count
--_insertStuff(dummyPositions13)
--end
-- Step 2.3:assign postion to dummy
dummyRadius = 0.02
for i = 1,count do
    objectHandles = "dummyHandle_"..i
    dummyObjectName = "dummy13_"..i
    objectHandles = sim.createDummy(dummyRadius,nil)
    sim.setObjectName(objectHandles,dummyObjectName)
    -- assign dummys' position
    sim.setObjectPosition(objectHandles,baseDummyHandle,dummyPositions13[i])
end


-- Step 6: generate position for dummy object(create object -> objectHandle -> )
count = 10
--for i = 1,count
--_insertStuff(dummyPositions24)

-- Step 3.3:assign postion to dummy
dummyRadius = 0.02
for i = 1,count do
    objectHandles = "dummyHandle_"..i
    dummyObjectName = "dummy24_"..i
    objectHandles = sim.createDummy(dummyRadius,nil)
    sim.setObjectName(objectHandles,dummyObjectName)
    -- assign dummys' position
    sim.setObjectPosition(objectHandles,baseDummyHandle,dummyPositions24[i])
end