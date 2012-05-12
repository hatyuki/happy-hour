#import('dart:html');

class Tone {
  final int    BUFFER_SIZE = 4096 * 3;
  final double PI_2        = Math.PI * 2;
  
  AudioContext context;
  List score;

  Tone ( ) {
    this.context = new AudioContext( );
    this.clearCode( );
  }

  addCode (String code) {
    var NOTE = {
                'A':  440.000000,
                'As': 466.163762,
                'B':  493.883301,
                'C':  523.251131,
                'Cs': 554.365262,
                'D':  587.329536,
                'Ds': 622.253967,
                'E':  659.255114,
                'F':  698.456463,
                'Fs': 739.988845,
                'G':  783.990872,
                'Gs': 830.609395,
    };
    
    this.score.add(NOTE[code]);
  }

  clearCode ( ) => this.score = new List( );

  generate ( ) {
    AudioBuffer  buffer = this.context.createBuffer(1, BUFFER_SIZE * this.score.length, this.context.sampleRate);
    Float32Array buf    = buffer.getChannelData(0);

    for (int i = 0; i < this.score.length ; i++) {
      for (int j = 0 ; j < BUFFER_SIZE ; j++) {
        buf[i*BUFFER_SIZE+j] = Math.sin(this.score[i] * PI_2 * j / this.context.sampleRate);
      }
    }

    AudioBufferSourceNode source = this.context.createBufferSource( );
    source.buffer = buffer;
    source.connect(this.context.destination, 0);
    source.noteOn(0);
  }
}

void main( ) {
  document.query('#status').innerHTML = 'Dart Running!';

  // C D E F G A B
  //var score = ['A', 'B', 'C', 'D', 'E', 'F', 'G'];
  //List score = ['A'];
  var score = ['C', 'D', 'E', 'F', 'E', 'D', 'C', 'E', 'F', 'G', 'A', 'G', 'F'];

  
  Tone tone = new Tone( );
  score.forEach((s) => tone.addCode(s));

  tone.generate( );
}
