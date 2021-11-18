import * as React from 'react';
import Slider from '@react-native-community/slider';

import {
  StyleSheet,
  View,
  Text,
  FlatList,
  SafeAreaView,
  ActivityIndicator,
} from 'react-native';
import {
  getHomeAccessories,
  getAccessoryServices,
  setAccessoryValue,
  getAuthorizationStatus,
} from 'rn-homekit';
import { useEffect, useState } from 'react';
import type { HMAccessory, HMService } from 'src/types';

export default function App() {
  const [connected, setConnected] = useState(false);
  const [accessories, setAccessories] = useState<HMAccessory[]>([]);
  const [services, setServices] = useState<HMService[]>([]);

  const getAccessories = () => {
    getHomeAccessories().then(async (myAccessories) => {
      setAccessories(myAccessories);
      const promises: Promise<HMService[]>[] = [];
      myAccessories.forEach((i) => {
        promises.push(getAccessoryServices(i.id));
      });
      const myServices = await Promise.all(promises);
      setServices(myServices.flat());
    });
  };

  function sleep(ms: number) {
    return new Promise((resolve) => setTimeout(resolve, ms));
  }

  useEffect(() => {
    const func = async () => {
      let loading = true;
      while (loading) {
        const status = await getAuthorizationStatus();
        if (status === 'authorized') {
          loading = false;
          setConnected(true);
          await sleep(500);
          getAccessories();
        }
        await sleep(200);
      }
    };

    func();
  }, []);

  return (
    <SafeAreaView style={styles.container}>
      {!connected && <ActivityIndicator size="large" />}
      <FlatList
        data={accessories}
        keyExtractor={(item) => item.id}
        renderItem={({ item }) => (
          <View>
            <Text>{item.name}</Text>
            <FlatList
              data={services.map((i) => {
                return {
                  ...i,
                  characteristics: i.characteristics.filter(
                    (j) => j.properties.writable === true
                  ),
                };
              })}
              renderItem={({ item: service }) => (
                <View>
                  <Text>{service.name}</Text>
                  <FlatList
                    data={service.characteristics}
                    renderItem={({ item: characteristic }) => (
                      <View>
                        <Text>{characteristic.characteristicType?.name}</Text>
                        <Slider
                          minimumValue={characteristic.minimumValue}
                          maximumValue={characteristic.maximumValue}
                          value={characteristic.value}
                          onSlidingComplete={async (v) => {
                            await setAccessoryValue({
                              serviceId: service.id,
                              accessoryId: item.id,
                              characteristicId: characteristic.id,
                              value: v,
                            });
                          }}
                        />
                      </View>
                    )}
                  />
                </View>
              )}
              keyExtractor={(item) => item.id}
            />
          </View>
        )}
      />
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
});
