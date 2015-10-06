/**
 * @package Personagem
 * @copyright Wanderson Teixeira (wandersonteixeira@live.com)
 * @created 03/11/2014
 * @version 1.1.0.0 06/10/2015
 * @description Classe que trata a fala e movimentos do personagem.
 * @internal 1.0.0.1, 04/11/2014 - Acrescentado parametro para nº de ciclos e tempo para iniciar a fala.
 * @internal 1.1.0.0, 06/10/2015 - Acrescentado parametro para bloquear a fala.
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

	import com.greensock.*;
	import com.greensock.easing.*;

	public class Personagem extends MovieClip {
		private var myRoot: Object; //Define o Root
		private var myParent: Object; //Define o Parent
		private var tempoFalaStart: Timer; //Quantidade de Ciclos de Fala
		private var tempoFalaStop: Timer; //Quantidade de Ciclos de Fala
		private var persArmazenado: MovieClip;

		public function Personagem() {
			addEventListener(Event.ADDED, beginClass);
		}

		private function beginClass(event: Event): void {
			myRoot = MovieClip(root);
			myParent = MovieClip(parent);
		}

		public function MyPersonagem(mcPersonagem: MovieClip, ciclosFala: Number = 0, inicioFala: Number = 0, travaFala: Boolean = false): void {
			persArmazenado = mcPersonagem;
			mcPersonagem.Cabeca.Boca.gotoAndStop(1);

			/*mcPersonagem.Boca.gotoAndStop(1);
			mcPersonagem.bracoDireito.gotoAndStop(1);
			mcPersonagem.bracoEsquerdo.gotoAndStop(1);			
			*/
			if (ciclosFala > 0 && !travaFala) {
				persArmazenado = mcPersonagem;
				tempoFalaStart = new Timer(inicioFala * 1000);
				var functionFala: Function = FalaStart(mcPersonagem, ciclosFala);
				tempoFalaStart.addEventListener(TimerEvent.TIMER, functionFala);
				tempoFalaStart.start();

				var functionFalaStop: Function = FalaStop(mcPersonagem);
				//if(inicioFala > ciclosFala) {
					tempoFalaStop = new Timer((ciclosFala + inicioFala) * 1000);					
					tempoFalaStop.addEventListener(TimerEvent.TIMER, functionFalaStop);
					tempoFalaStop.start();
				//} else {
					//tempoFalaStop = new Timer(ciclosFala * 1000);
					//tempoFalaStop.addEventListener(TimerEvent.TIMER, functionFalaStop);
					//tempoFalaStop.start();
				//}
			}
		}
		private function FalaStart(mcPersonagem: MovieClip, ciclosFala: Number): Function {
			return function (event: Event): void {
				//trace("FALA: " + tempoFalaStart.currentCount);
				mcPersonagem.Cabeca.Boca.gotoAndStop(1);
				mcPersonagem.Cabeca.Boca.play();
			}
		}

		private function FalaStop(mcPersonagem: MovieClip): Function {
			return function (event: Event): void {
				//trace("CICLO: " + tempoFalaStop.currentCount);
				tempoFalaStop.stop();
				tempoFalaStart.stop();
				tempoFalaStart.reset();
				mcPersonagem.Cabeca.Boca.gotoAndStop(1);
			}
		}
	}

}