-- attached to each leg tip

function sysCall_init()

	prox_FL = sim.getObjectHandle("prox_FL") -- proximity sensor on leg tip
						 -- sensor range is 0.002m in front of leg tip
	dummy_tip_FL = sim.getObjectHandle("dummy_tip_FL")
	tar = sim.getObjectHandle("tar") -- target
	cub = sim.getObjectHandle("Cuboid") -- static cube shape

end

function sysCall_sensing()

	--result,distance,det_pt,det_obj_hdl,det_surf_norm = sim.handleProximitySensor(prox_FL)
	res_FL,dist_FL,det_pt_FL = sim.checkProximitySensor(prox_FL,cub)
	if res_FL>0 then -- we detect the cube in front of the foot
		-- we connect
		sim.setLinkDummy(dummy_tip_FL,tar)
		sim.setObjectInt32Parameter(dummy_tip_FL,sim.dummyintparam_link_type,0)

	end

end

function sysCall_cleanup()

	sim.setLinkDummy(dummy_tip_FL,-1)

end
