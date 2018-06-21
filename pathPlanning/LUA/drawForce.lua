-- code to draw the contact forces
-- this code is attached to a dummy object in the model tree

function sysCall_init()

	-- get force sensor handles
	force_FR = sim.getObjectHandle("force_FR")
	force_HR = sim.getObjectHandle("force_HR")
	force_FL = sim.getObjectHandle("force_FL")
	force_HL = sim.getObjectHandle("force_HL")

	-- get leg tips handles
	tip_FR = sim.getObjectHandle("tip_FR")
	tip_HR = sim.getObjectHandle("tip_HR")
	tip_FL = sim.getObjectHandle("tip_FL")
	tip_HL= sim.getObjectHandle("tip_HL")

	-- set vector color
	color = {1,0,0} -- red

	-- set drawing object attributes
	-- we want lines that are always visible through other geometry and new lines overwrite old lines
	attrib = sim.drawing_lines + sim.drawing_cyclic + sim.drawing_overlay
	size = 10 -- line width (pixels)
	duplicateTolerance = 0.0
	maxItemCount = 1 -- maximum number of items this object can hold
	specular = nil
	emission = nil

	-- init some variables (fXX = force, tXX = torque, pTip_XX = position of tip, mat_XX = transformation matrix)
	fFR = {}
	tFR = {}
	fHR = {}
	tHR = {}
	fFL = {}
	tFL = {}
	fHL = {}
	tHL = {}
	pTip_FR = {}
	pTip_HR = {}
	pTip_FL = {}
	pTip_HL = {}
	mat_FR = {}
	mat_HR = {}
	mat_FL = {}
	mat_HL = {}

	-- create drawing objects
	vectorFR = sim.addDrawingObject(attrib,size,duplicateTolerance,tip_FR,maxItemCount,color,specular,emission)
	vectorHR = sim.addDrawingObject(attrib,size,duplicateTolerance,tip_HR,maxItemCount,color,specular,emission)
	vectorFL = sim.addDrawingObject(attrib,size,duplicateTolerance,tip_FL,maxItemCount,color,specular,emission)
	vectorHL = sim.addDrawingObject(attrib,size,duplicateTolerance,tip_HL,maxItemCount,color,specular,emission)

	-- read script parameters
	draw = sim.getScriptSimulationParameter(sim_handle_self,"drawForce")

end

function sysCall_cleanup() 
	-- Remove the containers:
	sim.removeDrawingObject(vectorFR)
	sim.removeDrawingObject(vectorHR)
	sim.removeDrawingObject(vectorFL)
	sim.removeDrawingObject(vectorHL)
end

function sysCall_sensing() 
	
	if draw then
		-- read force sensor values
		-- we don't care about the value of result
		-- we don't care about the value of torque (for the moment?)

		-- it is normal to get warnings at beginning of sim if there is "Median" or "Average" checked in sensor dialog
		result,fFR,tFR = sim.readForceSensor(force_FR)
		result,fHR,tHR = sim.readForceSensor(force_HR)
		result,fFL,tFL = sim.readForceSensor(force_FL)
		result,fHL,tHL = sim.readForceSensor(force_HL)
	
		-- put the force readings back into reference frame	
		-- first get transformation matrices of the force sensor frames wrt the reference frame
		mat_FR = sim.getObjectMatrix(force_FR,-1)
		mat_HR = sim.getObjectMatrix(force_HR,-1)
		mat_FL = sim.getObjectMatrix(force_FL,-1)
		mat_HL = sim.getObjectMatrix(force_HL,-1)

		-- then transform the vector into the reference frame

		-- Front Right
		fFR = sim.multiplyVector(mat_FR,fFR)
		fFR[1] = fFR[1] - mat_FR[4]
		fFR[2] = fFR[2] - mat_FR[8]
		fFR[3] = fFR[3] - mat_FR[12]
	
	
		-- Hind Right
		fHR = sim.multiplyVector(mat_HR,fHR)
		fHR[1] = fHR[1] - mat_HR[4]
		fHR[2] = fHR[2] - mat_HR[8]
		fHR[3] = fHR[3] - mat_HR[12]

		-- Front Left
		fFL = sim.multiplyVector(mat_FL,fFL)
		fFL[1] = fFL[1] - mat_FL[4]
		fFL[2] = fFL[2] - mat_FL[8]
		fFL[3] = fFL[3] - mat_FL[12]

		-- Hind Left
		fHL = sim.multiplyVector(mat_HL,fHL)
		fHL[1] = fHL[1] - mat_HL[4]
		fHL[2] = fHL[2] - mat_HL[8]
		fHL[3] = fHL[3] - mat_HL[12]

		-- then we scale the values down
		scalFact = 0.001
	
		-- Front Right
		pTip_FR = simGetObjectPosition(tip_FR,-1)

		fFR[1] = fFR[1]*scalFact + pTip_FR[1]
		table.insert(pTip_FR,fFR[1])

		fFR[2] = fFR[2]*scalFact + pTip_FR[2]
		table.insert(pTip_FR,fFR[2])

		fFR[3] = fFR[3]*scalFact + pTip_FR[3]
		table.insert(pTip_FR,fFR[3])

		-- Hind Right
		pTip_HR = simGetObjectPosition(tip_HR,-1)

		fHR[1] = fHR[1]*scalFact + pTip_HR[1]
		table.insert(pTip_HR,fHR[1])

		fHR[2] = fHR[2]*scalFact + pTip_HR[2]
		table.insert(pTip_HR,fHR[2])

		fHR[3] = fHR[3]*scalFact + pTip_HR[3]
		table.insert(pTip_HR,fHR[3])

		-- Front Left
		pTip_FL = simGetObjectPosition(tip_FL,-1)

		fFL[1] = fFL[1]*scalFact + pTip_FL[1]
		table.insert(pTip_FL,fFL[1])

		fFL[2] = fFL[2]*scalFact + pTip_FL[2]
		table.insert(pTip_FL,fFL[2])

		fFL[3] = fFL[3]*scalFact + pTip_FL[3]
		table.insert(pTip_FL,fFL[3])
	
		-- Hind Left
		pTip_HL = simGetObjectPosition(tip_HL,-1)

		fHL[1] = fHL[1]*scalFact + pTip_HL[1]
		table.insert(pTip_HL,fHL[1])

		fHL[2] = fHL[2]*scalFact + pTip_HL[2]
		table.insert(pTip_HL,fHL[2])

		fHL[3] = fHL[3]*scalFact + pTip_HL[3]
		table.insert(pTip_HL,fHL[3])
	
	
		-- add drawing items
		result = sim.addDrawingObjectItem(vectorFR,pTip_FR)
		result = sim.addDrawingObjectItem(vectorHR,pTip_HR)
		result = sim.addDrawingObjectItem(vectorFL,pTip_FL)
		result = sim.addDrawingObjectItem(vectorHL,pTip_HL)
	end

end
