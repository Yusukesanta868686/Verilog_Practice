import wave
import struct, array
import numpy as np
from scipy.io.wavfile import write
# 固定小数点数のリストを32ビット整数に変換
def txt_to_int32(fixed_point_list):
    int32_list = []
    for value in fixed_point_list:
        if value[0] == '1':
            for i in range(32):
                
                if value[i] == '1':
                    value = value[:i] + '0' + value[i + 1:]
                else:
                    value = value[:i] + '1' + value[i + 1:]
            int32_value = -int(value, 2) - 1
            #print("value: {}".format(int32_value))
        else:
            int32_value = int(value, 2)
        int32_list.append(int32_value)
    return int32_list

# 32ビット整数をバイト列に変換
def int32_to_bytes(int32_list):
    result = []
    for value in int32_list:
        result.append(np.clip(int(value / (2 ** 8)), -32768, 32767))
    return result

# WAVファイルを生成
def create_wav_file(output_file, int32_data, sample_rate=48000, num_channels=1):
    wav = wave.open(output_file, 'w')
    wav.setparams((num_channels, 4, sample_rate, 0, 'NONE', 'not compressed'))
    byte_data = array.array('h', int32_data).tobytes()

    wav.writeframes(byte_data)
    wav.close()

if __name__ == "__main__":
    input_file = 'output.txt'  # 入力ファイル名を指定
    output_file = 'output.wav'  # 出力WAVファイル名を指定

    # テキストファイルから固定小数点数を読み取り、リストに格納
    with open(input_file, 'r') as infile:
        fixed_point_data = [line.strip() for line in infile]
    


    # 固定小数点数を32ビット整数に変換
    int32_data = txt_to_int32(fixed_point_data)
    for i in range(10000):
        print(int32_data[i])
    int_max = max(int32_data)
    #for i in range(len(int32_data)):
    #    int32_data[i] = int(int32_data[i] / int_max)
    # 32ビット整数をバイト列に変換
    result = int32_to_bytes(int32_data)
    for i in range(10000):
        print(result[i])
    result = np.array(result).astype(np.int16)
    # WAVファイルを生成
    #create_wav_file(output_file, result)
    write(output_file, 48000, result)