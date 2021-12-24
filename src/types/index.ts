export interface HMAccessory {
  name: string;
  categoryType: string;
  categoryDescription: string;
  id: string;
  model?: string;
  manufacturer?: string;
  services: HMService[];
}

export interface HMService {
  id: string;
  name: string;
  serviceType: string;
  characteristics: HMCharacteristic[];
}

export interface HMCharacteristic {
  id: string;
  properties: {
    writable: boolean;
    readable: boolean;
    supportsEventNotification: boolean;
  };
  characteristicType: {
    name: LightChacteristicAction;
    type: DeviceTypes;
  } | null;
  value?: any;
  minimumValue?: number;
  maximumValue?: number;
}

export interface HMRoom {
  id: string;
  name: string;
  accessories: HMAccessory[];
}

export interface HMServiceGroup {
  id: string;
  name: string;
  services: HMService[];
}

export interface HMHome {
  id: string;
  name: string;
  isPrimary: boolean;
  rooms: HMRoom[];
  accessories: HMAccessory[];
  serviceGroups: HMServiceGroup[];
}

export type DeviceTypes = 'light';

export type LightChacteristicAction =
  | 'lightCurrentLevel'
  | 'lightHue'
  | 'lightLevel'
  | 'lightSaturation'
  | 'lightColorTemparature';

export type AuthStatus = 'authorized' | 'determined' | 'restricted';
