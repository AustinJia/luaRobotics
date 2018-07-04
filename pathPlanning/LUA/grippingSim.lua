-- attached to each leg tip

function sysCall_init()

	prox_HR = sim.getObjectHandle("prox_HR") -- proximity sensor on leg tip
						 -- sensor range is 0.002m in front of leg tip
	dummy_tip_HR = sim.getObjectAssociatedWithScript(sim.handle_self)
	--tar = sim.getObjectHandle("tar") -- target
	heightfield = sim.getObjectHandle("heightfield") -- static cube shape
	grip = true
	attached = false
	size = 0.01
	prox_HR_pos = {}
	prox_HR_mat = {}
	res_HR=-1
	dist_HR=0
	det_pt_HR={}
    newDum = -1
	
end

function sysCall_sensing()
--    simTime = sim.getSimulationTime()

--    if simTime > 15.0 then
--        grip = false
--    end

	res_HR,dist_HR,det_pt_HR = sim.checkProximitySensor(prox_HR,heightfield)

	if res_HR>0 then -- we detect the ground in front of the foot (less than 0.002m in front)
		if grip then -- if gripping is activated
			if not attached then -- if we are not already gripping
				attached = true -- we are now
				-- get position of detected point in world frame
				prox_HR_pos = sim.getObjectPosition(prox_HR,-1)
				prox_HR_mat = sim.getObjectMatrix(prox_HR,-1)
				det_pt_HR = sim.multiplyVector(prox_HR_mat,det_pt_HR)
				--det_pt_HR = {det_pt_HR[1]+prox_HR_pos[1],det_pt_HR[2]+prox_HR_pos[2],det_pt_HR[3]+prox_HR_pos[3]}
				-- we create an invisible dummy in front of the leg tip
				newDum = sim.createDummy(size)
				sim.setObjectPosition(newDum,-1,det_pt_HR)
				sim.setObjectInt32Parameter(newDum,sim.objintparam_visibility_layer,256)
				sim.setObjectParent(newDum,heightfield,true)
				-- we connect
				sim.setLinkDummy(dummy_tip_HR,newDum)
				sim.setObjectInt32Parameter(dummy_tip_HR,sim.dummyintparam_link_type,0)
			end
		else -- gripping deactivated
			if attached then -- we are attached
                attached = false -- we are not anymore
				-- we disconnect
				sim.setLinkDummy(dummy_tip_HR,-1)
				-- we delete the dummy
				if newDum>0 then	
                    sim.removeObject(newDum) -- delete potential dummy
                    newDum = -1
                end
			end
		end
	end
end

function sysCall_cleanup()

	sim.setLinkDummy(dummy_tip_HR,-1) -- delete any remaining dummy link
	if newDum>0 then	
		sim.removeObject(newDum) -- delete potential dummy
	end

end
