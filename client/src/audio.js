var AudioContextFunc = window.AudioContext || window.webkitAudioContext;
export var audioContext = new AudioContextFunc();

// reverb
// MaesHowe IR from http://www.openairlib.net/auralizationdb/content/maes-howe
reverbjs.extend(audioContext);
var reverbUrl = "http://reverbjs.org/Library/MaesHowe.m4a";
var reverb = audioContext.createReverbFromUrl(reverbUrl, function() {
  reverb.connect(audioContext.destination);
});


// webaudio soundfont player
var player = new WebAudioFontPlayer();
/* xylophone */
player.loader.decodeAfterLoading(audioContext, '_tone_0130_FluidR3_GM_sf2_file');
/* marimba */
player.loader.decodeAfterLoading(audioContext, '_tone_0120_FluidR3_GM_sf2_file');
/* acoustic guitar */
player.loader.decodeAfterLoading(audioContext, '_tone_0240_FluidR3_GM_sf2_file');
/* piano */
player.loader.decodeAfterLoading(audioContext, '_tone_0001_FluidR3_GM_sf2_file');

export var instruments = {
    'Xylophone': _tone_0130_FluidR3_GM_sf2_file,
    'Marimba': _tone_0120_FluidR3_GM_sf2_file,
    'Guitar': _tone_0240_FluidR3_GM_sf2_file,
    'Piano': _tone_0001_FluidR3_GM_sf2_file
};

export function playNote(trackId, instrument, tone, duration){
    if (trackId === 0) {
      player.queueWaveTable(audioContext, lowpassFilter
                            , instruments[instrument] , 0, (12*6+tone), duration*0.5, 0.5);
    }
    else {
      player.queueWaveTable(audioContext, lowpassFilter
                            , instruments[instrument], 0, (12*4+tone), duration*0.5, 0.3);
    }
  return false;
}


// audio processing
var compressor = audioContext.createDynamicsCompressor();
compressor.threshold.value = -30;
compressor.knee.value = 40;
compressor.ratio.value = 12;
compressor.attack.value = 0.15;
compressor.release.value = 0.25;
compressor.connect(reverb);

var highpassFilter = audioContext.createBiquadFilter();
highpassFilter.type = 'highpass';
highpassFilter.frequency.value = 50;
highpassFilter.connect(compressor);

var lowpassFilter = audioContext.createBiquadFilter();
lowpassFilter.type = 'lowpass';
lowpassFilter.frequency.value = 8000;
lowpassFilter.connect(highpassFilter);
