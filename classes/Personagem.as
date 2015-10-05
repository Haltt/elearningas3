/**
 * @author Wanderson Teixeira (wandersonteixeira@live.com)
 * @created 03/11/2014
 * @version 1.0.0.1 04/11/2014
 * @description Classe que trata a fala e movimentos do personagem.
 * @update 1.0.0.1 - Acrescentado parametro para nº de ciclos e tempo para iniciar a fala.
 **/

package {
	import flash.utils.*;
	import flash.events.*;
	import flash.display.*;

	import flash.net.*;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.net.navigateToURL;

	import flash.media.Sound;
	import flash.media.SoundLoaderContext;
	import flash.media.SoundChannel;
	import flash.media.SoundMixer;

	import com.greensock.*;
	import com.greensock.easing.*;

	public class Personagem extends MovieClip {
		//private var myRoot: Object; //Define o Root
		//private var myParent: Object; //Define o Parent
		//private var tempoFalaStart: Timer; //Quantidade de Ciclos de Fala
		//private var tempoFalaStop: Timer; //Quantidade de Ciclos de Fala
		//private var tempoFalaAudio: Timer;
		//private var persArmazenado: MovieClip;

		//private var myAudio: Sound;
		//private var myAudioOut: Sound = new Sound();

		//public function Personagem() {
		//	addEventListener(Event.ADDED, beginClass);
		//}

		//private function beginClass(event: Event): void {
		//	myRoot = MovieClip(root);
		//	myParent = MovieClip(parent);
		//}

		//public function MyPersonagem(mcPersonagem: MovieClip, ciclosFala: Number = 0, inicioFala: Number = 0, stringAudio: String = "", idAudio: Number = 0): void {
		//	//SoundMixer.stopAll();
		//	persArmazenado = mcPersonagem;
		//	mcPersonagem.Boca.gotoAndStop(1);
		//	mcPersonagem.bracoDireito.gotoAndStop(1);
		//	mcPersonagem.bracoEsquerdo.gotoAndStop(1);

		//	/*if (stringAudio != "") {
		//		var myURLRequest: URLRequest = new URLRequest("audio/" + stringAudio);
		//		myAudio = new Sound();
		//		myAudio.addEventListener(Event.COMPLETE, loaded);
		//		myAudio.load(myURLRequest);
		//		addEventListener(Event.ADDED, loaded);
		//	}*/

		//	if (ciclosFala > 0) {
		//		persArmazenado = mcPersonagem;
		//		tempoFalaStart = new Timer(inicioFala * 1000);
		//		var functionFala: Function = FalaStart(mcPersonagem, ciclosFala);
		//		tempoFalaStart.addEventListener(TimerEvent.TIMER, functionFala);
		//		tempoFalaStart.start();

		//		tempoFalaStop = new Timer(ciclosFala * 1000);
		//		var functionFalaStop: Function = FalaStop(mcPersonagem);
		//		tempoFalaStop.addEventListener(TimerEvent.TIMER, functionFalaStop);
		//		tempoFalaStop.start();
		//	}

		//	/*if (ciclosFala > 0) {
		//		persArmazenado = mcPersonagem;
		//		tempoFalaStart = new Timer(inicioFala * 1000);
		//		var functionFala: Function = FalaStart(mcPersonagem, ciclosFala);
		//		tempoFalaStart.addEventListener(TimerEvent.TIMER, functionFala);
		//		tempoFalaStart.start();

		//		tempoFalaStop = new Timer(ciclosFala * 1000);
		//		var functionFalaStop: Function = FalaStop(mcPersonagem);
		//		tempoFalaStop.addEventListener(TimerEvent.TIMER, functionFalaStop);
		//		tempoFalaStop.start();

		//		tempoFalaAudio = new Timer(inicioFala * 1000);
		//		var functionFalaAudio: Function = FalaAudio(stringAudio);
		//		tempoFalaAudio.addEventListener(TimerEvent.TIMER, functionFalaAudio);
		//		tempoFalaAudio.start();
		//	}*/
		//}

		//private function loaded(event: Event): void {
		//	myAudioOut.addEventListener(SampleDataEvent.SAMPLE_DATA, processSound);
		//	myAudioOut.play();

		//	trace("##### INFO PERSONAGEM ####");
		//	trace("###-> Nome: " + persArmazenado.name);
		//	//trace("###-> Start Fala: " + inicioFala);
		//	//trace("###-> Arq. Audio: audio/" + stringAudio);
		//	trace("##--> Tempo Audio: " + (myAudio.length / 1000));

		//	trace("");
		//}

		//private function processSound(event: SampleDataEvent): void {
		//	var bytes: ByteArray = new ByteArray();
		//	myAudio.extract(bytes, 4096);
		//	event.data.writeBytes(upOctave(bytes));
		//}

		//private function upOctave(bytes: ByteArray): ByteArray {
		//	var returnBytes: ByteArray = new ByteArray();
		//	bytes.position = 0;
		//	while (bytes.bytesAvailable > 0) {
		//		returnBytes.writeFloat(bytes.readFloat());
		//		returnBytes.writeFloat(bytes.readFloat());
		//		if (bytes.bytesAvailable > 0) {
		//			//bytes.position += 8;
		//		}
		//	}
		//	return returnBytes;
		//}

		//private function FalaStart(mcPersonagem: MovieClip, ciclosFala: Number): Function {
		//	return function (event: Event): void {
		//		trace("FALA: " + tempoFalaStart.currentCount);
		//		mcPersonagem.Boca.play();
		//	}
		//}

		//private function FalaStop(mcPersonagem: MovieClip): Function {
		//	return function (event: Event): void {
		//		trace("CICLO: " + tempoFalaStop.currentCount);
		//		tempoFalaStop.stop();
		//		tempoFalaStart.stop();
		//		//tempoFalaAudio.stop();
		//		mcPersonagem.Boca.gotoAndStop(1);
		//	}
		//}

		//private function FalaAudio(stringAudio: String): Function {
		//	return function (event: Event): void {
		//		if (stringAudio != "") {
		//			var myChannel: SoundChannel = new SoundChannel();
		//			myAudio.load(new URLRequest(stringAudio));
		//			myChannel = myAudio.play();
		//			trace(stringAudio);
		//			trace(myChannel.position);
		//			trace(myAudio.url);
		//			trace(myAudio.length);

		//			//tempoFalaAudio.stop();
		//			tempoFalaAudio.removeEventListener(TimerEvent.TIMER, FalaAudio);
		//		}
		//	}
		//}

		//private function errorHandler(event: IOErrorEvent): void {
		//	trace("Couldn't load the file " + event.text);
		//}
	}

}