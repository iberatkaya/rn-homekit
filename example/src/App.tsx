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
  getHomes,
  setAccessoryValue,
  getAuthorizationStatus,
} from 'rn-homekit';
import { useEffect, useState } from 'react';
import type { HMHome } from 'src/types';

export default function App() {
  const [connected, setConnected] = useState(false);
  const [homes, setHomes] = useState<HMHome[]>([]);

  const loadHomes = async () => {
    const myHomes = await getHomes();
    setHomes(myHomes);
  };

  function sleep(ms: number) {
    return new Promise((resolve) => setTimeout(resolve, ms));
  }

  useEffect(() => {
    const func = async () => {
      const status = await getAuthorizationStatus();
      if (status === 'authorized') {
        setConnected(true);
        await sleep(500);
        await loadHomes();
      }
    };

    func();
  }, []);

  return (
    <SafeAreaView style={styles.container}>
      {!connected && <ActivityIndicator size="large" />}
      <FlatList
        data={homes}
        contentContainerStyle={{ minWidth: '80%' }}
        keyExtractor={(item) => item.id}
        renderItem={({ item }) => (
          <View>
            <Text>{item.name}</Text>
            <FlatList
              data={item.accessories}
              keyExtractor={(item) => item.id}
              renderItem={(accessoryItem) => (
                <View>
                  <Text>{accessoryItem.item.name}</Text>
                  <FlatList
                    data={accessoryItem.item.services.sort((i, j) =>
                      i.id > j.id ? 1 : -1
                    )}
                    keyExtractor={(item) => item.id}
                    renderItem={(serviceItem) => (
                      <View>
                        <Text>{serviceItem.item.name}</Text>
                        <FlatList
                          data={serviceItem.item.characteristics
                            .filter((i) => i.properties.writable)
                            .sort((i, j) => (i.id > j.id ? 1 : -1))}
                          keyExtractor={(item) => item.id}
                          renderItem={({ item }) => (
                            <View
                              style={{
                                borderColor: '#ccc',
                                borderRadius: 8,
                                marginVertical: 4,
                              }}
                            >
                              <Text>
                                {item.characteristicType
                                  ? 'Name: ' +
                                    item.characteristicType.name +
                                    ', Type: ' +
                                    item.characteristicType.type
                                  : ''}
                              </Text>
                              <Text>
                                Min: {item.minimumValue} Max:{' '}
                                {item.maximumValue}
                              </Text>
                              <Text>{item.value}</Text>
                              <Slider
                                minimumValue={item.minimumValue}
                                maximumValue={item.maximumValue}
                                value={item.value}
                                onSlidingComplete={async (value) => {
                                  try {
                                    await setAccessoryValue({
                                      accessoryId: accessoryItem.item.id,
                                      serviceId: serviceItem.item.id,
                                      characteristicId: item.id,
                                      value,
                                    });
                                    await loadHomes();
                                  } catch (e) {
                                    console.error(e);
                                  }
                                }}
                              />
                            </View>
                          )}
                        />
                      </View>
                    )}
                  />
                </View>
              )}
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
