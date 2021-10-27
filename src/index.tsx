import { NativeModules, Platform } from 'react-native';
import type { HMAccessory, HMService } from './types';

const LINKING_ERROR =
  `The package 'rn-homekit' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo managed workflow\n';

const RnHomekit = NativeModules.RnHomekit
  ? NativeModules.RnHomekit
  : new Proxy(
      {},
      {
        get() {
          throw new Error(LINKING_ERROR);
        },
      }
    );

export function multiply(a: number, b: number): Promise<number> {
  return RnHomekit.multiply(a, b);
}

export function getHomeAccessories(): Promise<Array<HMAccessory>> {
  return RnHomekit.getHomeAccessories();
}

export function getAccessory(accessoryId: string): Promise<HMAccessory> {
  return RnHomekit.getAccessory(accessoryId);
}

export function getAccessoryServices(
  accessoryId: string
): Promise<Array<HMService>> {
  return RnHomekit.getAccessoryServices(accessoryId);
}

export function setAccessoryValue({
  accessoryId,
  serviceId,
  characteristicId,
  value,
}: {
  accessoryId: string;
  serviceId: string;
  characteristicId: string;
  value: any;
}): Promise<void> {
  return RnHomekit.setAccessoryValue(
    accessoryId,
    serviceId,
    characteristicId,
    value
  );
}
