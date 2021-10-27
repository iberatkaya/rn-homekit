import HomeKit

struct CharacteristicType {
    init(type: DeviceTypes, name: ChacteristicAction) {
        self.type = type
        self.name = name
    }

    let type: DeviceTypes
    let name: ChacteristicAction

    func toDict() -> [String: Any] {
        return [
            "type": type.rawValue,
            "name": name.rawValue
        ]
    }
}

enum DeviceTypes: String {
    case Light = "light"
}

enum ChacteristicAction: String {
    case lightCurrentLevel
    case lightHue
    case lightLevel
    case lightSaturation
    case lightColorTemparature
}

func mapCharacteristicToString(_ characteristic: String) -> CharacteristicType? {
    switch characteristic {
        case HMCharacteristicTypeCurrentLightLevel:
            return CharacteristicType(type: DeviceTypes.Light, name: ChacteristicAction.lightCurrentLevel)
        case HMCharacteristicTypeHue:
            return CharacteristicType(type: DeviceTypes.Light, name: ChacteristicAction.lightHue)
        case HMCharacteristicTypeBrightness:
            return CharacteristicType(type: DeviceTypes.Light, name: ChacteristicAction.lightLevel)
        case HMCharacteristicTypeSaturation:
            return CharacteristicType(type: DeviceTypes.Light, name: ChacteristicAction.lightSaturation)
        case HMCharacteristicTypeColorTemperature:
            return CharacteristicType(type: DeviceTypes.Light, name: ChacteristicAction.lightColorTemparature)

        default:
            return nil
    }
}
