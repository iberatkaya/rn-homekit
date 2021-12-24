import HomeKit

@objc(RnHomekit)
class RnHomekit: NSObject {
    var homeManager: HMHomeManager!

    override init() {
        super.init()
        homeManager = HMHomeManager()
    }
    
    @objc
    func authorizationStatus(_ resolve: RCTPromiseResolveBlock, withRejecter reject: RCTPromiseRejectBlock) -> Void {
        let status = self.homeManager.authorizationStatus
        resolve(mapAuthStatusToString(status)?.rawValue)
    }

    @objc static func requiresMainQueueSetup() -> Bool {
        return false
    }

    @objc(multiply:withB:withResolver:withRejecter:)
    func multiply(a: Float, b: Float, resolve: RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) -> Void {
        resolve(a*b)
    }
    
    @objc
    func getHomes(_ resolve: RCTPromiseResolveBlock, withRejecter reject: RCTPromiseRejectBlock) -> Void {
        let homes = homeManager.homes.map({ $0.toDict() })
        resolve(homes)
    }
    
    @objc
    func getAccessory(_ accessoryId: String, resolve: RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) -> Void {
        homeManager.homes.forEach { home in
            home.accessories.forEach({ accessory in
                if accessory.uniqueIdentifier.uuidString == accessoryId {
                    resolve(accessory.toDict())
                }
            })
        }
    }

    @objc
    func getAccessoryServices(_ accessoryId: String, withResolver resolve: RCTPromiseResolveBlock, withRejecter reject: RCTPromiseRejectBlock) -> Void {
        homeManager.homes.forEach { home in
            home.accessories.forEach({ accessory in
                if accessory.uniqueIdentifier.uuidString == accessoryId {
                    var services: [[String: Any]] = []
                    accessory.services.forEach({ service in services.append(service.toDict()) })
                    resolve(services)
                }
            })
        }
    }

    @objc
    func setAccessoryValue(_ accessoryId: String, withServiceId serviceId: String, withCharacteristicId characteristicId: String, withValue value: Any, withResolver resolve: @escaping RCTPromiseResolveBlock, withRejecter reject: @escaping RCTPromiseRejectBlock) -> Void {
        var found = false
        homeManager.homes.forEach { home in
            home.accessories.forEach({ accessory in
                if accessory.uniqueIdentifier.uuidString == accessoryId {
                    accessory.services.forEach({ service in
                        if service.uniqueIdentifier.uuidString == serviceId {
                            service.characteristics.forEach({ characteristic in
                                if characteristic.uniqueIdentifier.uuidString == characteristicId {
                                    found = true
                                    characteristic.writeValue(value) { error in
                                        if let error = error {
                                            reject("Error", error.localizedDescription, nil)
                                        } else {
                                            resolve(true)
                                        }
                                    }
                                }
                            })
                        }
                    })
                }
            })
        }
        if !found {
            reject("Error", "Could not find characteristic!", nil)
        }
     }
}
