import HomeKit

@objc(RnHomekit)
class RnHomekit: NSObject {
    var homeManager: HMHomeManager!

    override init() {
        super.init()
        homeManager = HMHomeManager()
    }

    @objc(multiply:withB:withResolver:withRejecter:)
    func multiply(a: Float, b: Float, resolve: RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) -> Void {
        resolve(a*b)
    }
    
    @objc
    func getHomeAccessories(_ resolve: RCTPromiseResolveBlock, withRejecter reject: RCTPromiseRejectBlock) -> Void {
        var accessories: [[String: Any]] = []
        homeManager.homes.forEach { home in
            home.accessories.forEach({ accessory in accessories.append(accessory.toDict()) })
        }
        resolve(accessories)
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
        homeManager.homes.forEach { home in
            home.accessories.forEach({ accessory in
                if accessory.uniqueIdentifier.uuidString == accessoryId {
                    accessory.services.forEach({ service in
                        if service.uniqueIdentifier.uuidString == serviceId {
                            service.characteristics.forEach({ characteristic in
                                if characteristic.uniqueIdentifier.uuidString == characteristicId {
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
    }
}
