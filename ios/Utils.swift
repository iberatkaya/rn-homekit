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
    if characteristic == HMCharacteristicTypeCurrentLightLevel {
        return CharacteristicType(type: DeviceTypes.Light, name: ChacteristicAction.lightCurrentLevel)
    } else if characteristic == HMCharacteristicTypeHue {
        return CharacteristicType(type: DeviceTypes.Light, name: ChacteristicAction.lightHue)
    } else if characteristic == HMCharacteristicTypeBrightness {
        return CharacteristicType(type: DeviceTypes.Light, name: ChacteristicAction.lightLevel)
    } else if characteristic == HMCharacteristicTypeSaturation {
        return CharacteristicType(type: DeviceTypes.Light, name: ChacteristicAction.lightSaturation)
    } else if characteristic == HMCharacteristicTypeColorTemperature {
        return CharacteristicType(type: DeviceTypes.Light, name: ChacteristicAction.lightColorTemparature)
    }
    return nil
}

enum AuthStatus: String {
    case authorized
    case determined
    case restricted
}

func mapAuthStatusToString(_ status: HMHomeManagerAuthorizationStatus) -> AuthStatus? {
    if status.contains(.authorized) {
        return AuthStatus.authorized
    } else if status.contains(.determined) {
        return AuthStatus.determined
    } else if status.contains(.restricted) {
        return AuthStatus.restricted
    }
    return nil
}
