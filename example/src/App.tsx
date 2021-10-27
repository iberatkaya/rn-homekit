import * as React from 'react';
import Slider from '@react-native-community/slider';

import { StyleSheet, View, Text, Button } from 'react-native';
import {
  getHomeAccessories,
  getAccessoryServices,
  setAccessoryValue,
} from 'rn-homekit';
import { useState } from 'react';

export default function App() {
  const [value, setValue] = useState(0);

  const setBrightness = () => {
    getHomeAccessories().then((accessories) => {
      getAccessoryServices(accessories[0].id).then((services) => {
        services.forEach((c) => {
          c.characteristics.forEach((characteristic) => {
            if (
              characteristic.properties.writable &&
              characteristic.characteristicType?.type === 'light' &&
              characteristic.characteristicType?.name === 'lightLevel'
            ) {
              setAccessoryValue({
                accessoryId: accessories[0].id,
                characteristicId: characteristic.id,
                serviceId: c.id,
                value: value,
              });
            }
          });
        });
      });
    });
  };

  React.useEffect(() => {
    setBrightness();
  }, []);

  return (
    <View style={styles.container}>
      <Text>Brightness: {value}</Text>
      <Slider
        style={{ width: 200, height: 40 }}
        minimumValue={0}
        maximumValue={100}
        minimumTrackTintColor="#77f"
        maximumTrackTintColor="#cef"
        value={value}
        onValueChange={setValue}
      />
      <Button title="call" onPress={setBrightness} />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
});
