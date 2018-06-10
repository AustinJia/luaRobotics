--lua 5.3

--define Function
function _generateRandomPosition()
    a = 
end


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
--the leg 1 and leg3 will be position will be                    (0,1,0)          (0,2,0)          (0,3,0)          (0,4,0)          (0,5,0) 
--                                                   (0.2,0.5,0)       (0.2,1.5,0)       (0.2,2.5,0)    (0.2,3.5,0)        (0.2,4.5,0)
--the leg 2 and leg4 will be position will be                    (2,1,0)          (2,2,0)          (2,3,0)          (2,4,0)          (2,5,0) 
--                                                   (2.2,0.5,0)       (2.2,1.5,0)       (2.2,2.5,0)    (2.2,3.5,0)        (2.2,4.5,0)

--Step 1: create a base dummy
baseDummyHandle = sim.createDummy(0.01,nil)
sim.setObjectName(baseDummyHandle,"baseDummy")


-- Step 2: simulate for leg 1 and leg 3
-- Step 2.1: create dummy Handle Table:
dummyHandles13 = {}
dummyPositions13 = {{0.2,1.5,0},{0,1,0},{0.2,1.5,0},{0,2,0},{0.2,2.5,0},{0,3,0},{0.2,3.5,0},{0,4,0},{0.2,4.5,0},{0,5,0}}

-- Step 2.2: generate position for dummy object(create object -> objectHandle -> )
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

-- Step 3: simulate for leg 2 and leg 4
dummyHandles24 = {}
dummyPositions24 = {{2.2,1.5,0},{2,1,0},{2.2,1.5,0},{2,2,0},{2.2,2.5,0},{2,3,0},{2.2,3.5,0},{2,4,0},{2.2,4.5,0},{2,5,0}}


-- Step 3.2: generate position for dummy object(create object -> objectHandle -> )
count = 10
--for i = 1,count
--_insertStuff(dummyPositions24)

-- Step 3.3:assign postion to dummy
dummyRadius = 0.02
for i = 1,count do
    objectHandles = "dummyHandle_"..i
    dummyObjectName = "dummy13_"..i
    objectHandles = sim.createDummy(dummyRadius,nil)
    sim.setObjectName(objectHandles,dummyObjectName)
    -- assign dummys' position
    sim.setObjectPosition(objectHandles,baseDummyHandle,dummyPositions24[i])
end


function sysCall_init()

    options = 1
    intParam = {0,0,0,0,0,0,0,0}
    floatParam = {0,100,0,0,0,0,0,0,0,0,0,0,0,0,0}
    color = nil
    proxSens = sim.createProximitySensor(sim.proximitysensor_ray_subtype, sim.objectspecialproperty_detectable_laser, options, intParam, floatParam, color)

end

sim.setObjectPosition(proxSens,baseDummyHandle,{0,0,1.5})
result,data=sim.handleProximitySensor(proxSens_1)