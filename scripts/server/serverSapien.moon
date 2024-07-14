{loadOrder: 1, onload: (serverSapien) =>
    nameLists = mjrequire "common/nameLists"
    rng = mjrequire "common/randomNumberGenerator"
    serverGOM = nil
    mj\log "stuff should be logged here"

    superInit = serverSapien.init
    serverSapien.init = (serverGOM_, serverWorld_, serverTribe_, serverDestination_, serverStorageArea_) =>
        superInit self, serverGOM_, serverWorld_, serverTribe_, serverDestination_, serverStorageArea_
        serverGOM = serverGOM_

    superCreateInitialTribeSpawnSapienStates = serverSapien.createInitialTribeSpawnSapienStates
    serverSapien.createInitialTribeSpawnSapienStates = (triFaceUniqueID, randomSeed, lifeStageIndex, extraState, initialRoles, temperatureZones, isNomad, tribeCenterNormalized) =>
        sapien = superCreateInitialTribeSpawnSapienStates self, triFaceUniqueID, randomSeed, lifeStageIndex, extraState, initialRoles, temperatureZones, isNomad, tribeCenterNormalized
        mj\log "naming sapien: ", sapien
        sapien.sharedState.praenomen = nameLists\generatePraenomen triFaceUniqueID, randomSeed, sapien.sharedState.isFemale
        sapien.sharedState.nomen = nameLists\generateNomen triFaceUniqueID, randomSeed, sapien.sharedState.isFemale
        sapien.sharedState.cognomen = nameLists\generateCognomen triFaceUniqueID, randomSeed, sapien.sharedState.isFemale
        mj\log "new sap state: ", sapien
        sapien.sharedState.name = sapien.sharedState.praenomen .. " " .. sapien.sharedState.nomen .. " " .. sapien.sharedState.cognomen
        mj\log "named new sapien: ", sapien.sharedState.name
        sapien

    superCreateChildFromMother = serverSapien.createChildFromMother
    serverSapien.createChildFromMother = (motherSapien) =>
        childSapienID = superCreateChildFromMother self, motherSapien
        childSapien = serverGOM\getObjectWithID childSapienID

        childSapien.sharedState.praenomen = nameLists\generatePraenomen motherSapien.sharedState.tribeID, rng\getRandomSeed!, childSapien.sharedState.isFemale
        if motherSapien.sharedState.pregnancyFatherInfo
            fatherSapienID = motherSapien.sharedState.pregnancyFatherInfo.fatherID
            fatherSapien = serverGOM\getObjectWithID fatherSapienID
            childSapien.sharedState.nomen = fatherSapien.sharedState.nomen
        else
            childSapien.sharedState.nomen = nameLists\generateNomen motherSapien.sharedState.tribeID, rng\getRandomSeed!, childSapien.sharedState.isFemale
        childSapien.sharedState.cognomen = nameLists\generateCognomen motherSapien.sharedState.tribeID, rng\getRandomSeed!, childSapien.sharedState.isFemale
        childSapien.sharedState.name = childSapien.sharedState.praenomen .. " " .. childSapien.sharedState.nomen .. " " .. childSapien.sharedState.cognomen
        mj\log "named baby sapien: ", childSapien.sharedState.name
        childSapienID
}