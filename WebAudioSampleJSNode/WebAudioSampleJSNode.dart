#import('dart:html');

void main() {
  document.query('#status').innerHTML = 'Dart Running!';

  AudioContext audioContext = new AudioContext();
  
  final int SAMPLE_RATE = 44100;
  final double PI_2 = Math.PI * 2;
  final int BUFFER_SIZE = 4096;
  AudioBuffer audioBuffer = audioContext.createBuffer(1, BUFFER_SIZE, SAMPLE_RATE);
  
  Float32Array buf = audioBuffer.getChannelData(0);
  
  for (int i = 0; i < 4096; ++i) {
    buf[i] = Math.sin(440 * PI_2 * i / SAMPLE_RATE);
  }
  
  AudioBufferSourceNode source = audioContext.createBufferSource(); 
  source.buffer = audioBuffer;
  source.connect(audioContext.destination, 0);
  source.noteOn(0);
  
}
