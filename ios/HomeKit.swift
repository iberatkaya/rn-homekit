import HomeKit

extension HMAccessory {
    func toDict() -> [String: Any?] {
        var dict: [String: Any?] = [
            "name": name,
            "categoryType": category.categoryType,
            "categoryDescription": category.description,
            "id": uniqueIdentifier.uuidString,
            "services": services.map({ $0.toDict() }),
            "manufacturer": manufacturer,
        ]
        if #available(iOS 11.0, *) {
            dict["model"] = model
            return dict
        } else {
            return dict
        }
    }
}

extension HMService {
    func toDict() -> [String: Any] {
        return [
            "id": uniqueIdentifier.uuidString,
            "name": name,
            "serviceType": serviceType,
            "characteristics": characteristics.map { $0.toDict() },
            "description": description,
        ]
    }
}

private func propertiesToDict(_ properties: [String]) -> [String: Bool] {
    return [
        "writable": properties.contains(HMCharacteristicPropertyWritable),
        "readable": properties.contains(HMCharacteristicPropertyReadable),
        "supportesEventNotification": properties.contains(HMCharacteristicPropertySupportsEventNotification),
    ]
}

extension HMCharacteristic {
    func toDict() -> [String: Any?] {
        return [
            "id": uniqueIdentifier.uuidString,
            "properties": propertiesToDict(properties),
            "characteristicType": mapCharacteristicToString(characteristicType)?.toDict(),
            "value": value,
            "minimumValue": metadata?.minimumValue,
            "maximumValue": metadata?.maximumValue,
        ]
    }
}

extension HMRoom {
    func toDict() -> [String: Any] {
        return [
            "id": uniqueIdentifier.uuidString,
            "name": name,
            "accessories": accessories.map { $0.toDict() },
        ]
    }
}

extension HMServiceGroup {
    func toDict() -> [String: Any] {
        return [
            "id": uniqueIdentifier.uuidString,
            "name": name,
            "services": services.map { $0.toDict() },
        ]
    }
}

extension HMHome {
    func toDict() -> [String: Any] {
        return [
            "id": uniqueIdentifier.uuidString,
            "name": name,
            "isPrimary": isPrimary,
            "rooms": rooms.map { $0.toDict() },
            "accessories": accessories.map { $0.toDict() },
            "serviceGroups": serviceGroups.map { $0.toDict() },
        ]
    }
}
