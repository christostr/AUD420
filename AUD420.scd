(
s.waitForBoot {
    var duration = 120;
    var numSynths = 5;


    SynthDef(\ambientSynth, {
        |out = 0, freq = 220, amp = 0.1, pan = 0, dur = 10|
        var env, osc, sig;
        env = EnvGen.kr(Env.perc(0.01, dur, amp, -4), doneAction: 2);
        osc = Mix([SinOsc.ar(freq, 0, env), SinOsc.ar(freq * 0.5, 0, env)]);
        sig = Pan2.ar(osc, pan);
        Out.ar(out, sig);
    }).add;


    SynthDef(\droneSynth, {
        |out = 0, freq = 110, amp = 0.4|
        var osc, sig;
        osc = Mix([SinOsc.ar(freq), SinOsc.ar(freq * 0.5)]);
        sig = Pan2.ar(osc, 0, amp);
        Out.ar(out, sig);
    }).add;

    s.sync;


    ~generateSynth = {
        var freq, amp, pan, dur, delayTime, synth;
        freq = [110, 165, 220, 275, 330, 440].choose;
        amp = [0.05, 0.1, 0.15, 0.2].choose;
        pan = [-1.0, -0.5, 0.0, 0.5, 1.0].choose;
        dur = [2, 4, 5, 7].choose;


        synth = Synth(\ambientSynth, [\freq, freq, \amp, amp, \pan, pan, \dur, dur]);


        delayTime = dur + rrand(0.5, 2);
        SystemClock.sched(delayTime, { ~generateSynth.value });
    };


    Synth(\droneSynth, [\freq, 110, \amp, 0.3]);


    numSynths.do { ~generateSynth.value };


    SystemClock.sched(duration, { s.quit; });
};
)
