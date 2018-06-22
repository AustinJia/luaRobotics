function sysCall_init()

    dum = sim.getObjectHandle("Dummy")
    dum0 = sim.getObjectHandle("Dummy0")
    dum1 = sim.getObjectHandle("Dummy1")  
    dum2 = sim.getObjectHandle("Dummy2")

    dum_FR = sim.getObjectHandle("dummy_tip_FR")
    dum_FL = sim.getObjectHandle("dummy_tip_FL")
    dum_HR = sim.getObjectHandle("dummy_tip_HR")    
    dum_HL = sim.getObjectHandle("dummy_tip_HL")
    
    joint_3_FL = sim.getObjectHandle("joint_3_FL")
    joint_3_FR = sim.getObjectHandle("joint_3_FR")
    joint_3_HL = sim.getObjectHandle("joint_3_HL")
    joint_3_HR = sim.getObjectHandle("joint_3_HR")

    t_pos = -80*math.pi/180
    first = true
end

function sysCall_actuation()

    simTime = sim.getSimulationTime()
    
    if simTime > 5.0 then
        if first then
            first = false
            sim.setLinkDummy(dum,dum_FL)
            sim.setObjectInt32Parameter(dum,sim.dummyintparam_link_type,0)
            sim.setLinkDummy(dum0,dum_FR)
            sim.setObjectInt32Parameter(dum0,sim.dummyintparam_link_type,0)
            sim.setLinkDummy(dum1,dum_HL)
            sim.setObjectInt32Parameter(dum1,sim.dummyintparam_link_type,0)
            sim.setLinkDummy(dum2,dum_HR)
            sim.setObjectInt32Parameter(dum2,sim.dummyintparam_link_type,0)
            sim.setJointTargetPosition(joint_3_HL,t_pos)
            sim.setJointTargetPosition(joint_3_HR,t_pos)
            sim.setJointTargetPosition(joint_3_FL,t_pos)
            sim.setJointTargetPosition(joint_3_FR,t_pos)
        end
    end
end

function sysCall_cleanup()

    sim.setLinkDummy(dum,-1)
    sim.setLinkDummy(dum0,-1)
    sim.setLinkDummy(dum1,-1)
    sim.setLinkDummy(dum2,-1)

end
