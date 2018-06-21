-- attached to each leg tip

function sysCall_init()

	prox_FL = sim.getObjectHandle("prox_FL") -- proximity sensor on leg tip
						 -- sensor range is 0.002m in front of leg tip
	dummy_tip_FL = sim.getObjectHandle("dummy_tip_FL")
	tar = sim.getObjectHandle("tar") -- target
	cub = sim.getObjectHandle("Cuboid") -- static cube shape

end

function sysCall_sensing()

	-- GRIPPING SIMULATION PROCEDURE
		-- Get "EndOfMove" trigger by controller. This means the controller believes he sent the foot to the right position
		-- Check for terrain presence through proximity sensor
		-- If terrain found
			-- A) Create dummy on terrain then connect to it
			-- OR
			-- B) Connect to the nearest already existing dummy
		-- If terrain not found
			-- End? Recuperation procedure?

	res_FL,dist_FL,det_pt_FL = sim.checkProximitySensor(prox_FL,cub)
	if (dist_FL~=nil) and (dist_FL-0.05 < 0.002) then -- we detect the cube in front of the foot
		-- we connect to already existing dummy (carefully placed at the right position)
		sim.setLinkDummy(dummy_tip_FL,tar)
		sim.setObjectInt32Parameter(dummy_tip_FL,sim.dummyintparam_link_type,0)

	end

end

function sysCall_cleanup()

	sim.setLinkDummy(dummy_tip_FL,-1)

end
