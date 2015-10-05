/**
 * @package Curso
 * @copyright Wanderson Teixeira (wandersonteixeira@live.com)
 * @created 29/10/2014
 * @version 1.3.1, 23/04/2015
 * @internal Classe principal, onde está tratado a navegação e funcionalidades padrões.
 * @internal 1.0.1, 30/10/2014 - Ajuste que trava o botão Avançar funcionando.
 * @internal 1.0.2, 31/10/2014 - Implementado o contador de forma dinâmica, fazendo sua montagem automaticamente com base na quantidade de telas do curso.
 * @internal 1.1.0, 26/12/2014 - Classe personagem incluida na classe principal para tratamento de movimentações.
 * @internal 1.2.0, 31/03/2015 - Scorm gravando as telas e retornando onde parou, animação liberando a tela após sua conclusão e com delay caso necessário.
 * @internal 1.3.0, 23/04/2015 - Menu funcionando quando a tela for maior do que a tela atual, falta resolver para ficar liberado quando a opção já tiver sido liberada.
 * @internal 1.3.1, 24/04/2015 - Menu funcionando quando a tela for maior do que a tela atual e retornando ao curso pela plataforma.
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
	
	import flash.ui.Keyboard;
	import flash.ui.Mouse;
	
	import flash.external.*;

	import com.greensock.*;
	import com.greensock.easing.*;

	public class Curso extends MovieClip {
		//VARIAVEIS DE CONFIGURAÇÃO
		private var myRoot: Object; //Define o Root
		private var myParent: Object; //Define o Parent		
		private var totalTelas: Number; //Armazena a Quantidade de Telas do Curso
		private var telaAtualScorm: Number; //Tela vinda do Scorm

		private var tempoTela: Timer; //Define o tempo para liberar a tela
		private var tempoHint: Timer; //Define o tempo para liberar o hint
		private var tempoTelaVoltar: Timer; //Define um delay para o botão voltar

		public var telaAtual: Number; //Armazena a Tela Atual
		public var frameAtual: Number; //Armazena o Frame Atual dentro da Tela Atual

		public var ConfigMenu: Array; //Armazena a tela inicial de cada item do menu
		public var ConfigAjuda: Boolean;

		//FUNÇÃO PRINCIPAL
		public function Curso() {
			addEventListener(Event.ADDED, beginClass); //ADICIONA AS FUNCIONALIDADES NO CURSO
		}

		//CONFIGURAÇÕES DE INICIALIZAÇÃO
		private function beginClass(event: Event): void {
			myRoot = MovieClip(root); //Cria uma variável facilitadora para acesso a função (objeto) "root".
			myParent = MovieClip(parent); //Cria uma variável facilitadora para acesso a função (objeto) "parent".

			//Informa a tela atual do curso.
			telaAtualScorm = ExternalInterface.call("ultimaTela"); //Pega a última tela no scorm.			
			if(telaAtualScorm >= 3 && (String(telaAtualScorm) != "" || String(telaAtualScorm) != "undefined")) {
				telaAtual = telaAtualScorm;
			} else {
				telaAtual = 1;
				trace(ConfigAjuda);
				if(ConfigAjuda) {
					myRoot.MenuAjuda.gotoAndStop(2);
				} else {
					myRoot.MenuAjuda.gotoAndStop(1);
				}
				frameAtual = myRoot["Tela" + telaAtual].currentFrame; //Frame Atual dentro da Tela Atual
			}
			myRoot.gotoAndStop(telaAtual); //Exibe a Tela (Frame) Atual
			totalTelas = myRoot.totalFrames; //Informa a quantidade de telas do curso.

			//Contador
			//Mostra a tela atual na tela.
			if(totalTelas < 10) {
				myRoot.txtTotalTela.text = "0" + (totalTelas - 2);
			} else {
				myRoot.txtTotalTela.text = totalTelas - 2;
			}
			//Mostra o total de telas na tela.
			if(totalTelas < 10) {
				myRoot.txtTelaAtual.text = "0" + telaAtual;
			} else {
				myRoot.txtTelaAtual.text = telaAtual;
			}

			//Estado dos Botões (Avançar e Voltar)
			myRoot.btnAvancar.gotoAndStop(3); //Inicia o botão avançar no estado de travado.
			myRoot.btnVoltar.gotoAndStop(3); //Inicia o botão voltar no estado de travado. 			
		}

		//## NAVEGAÇÃO
		//### TRAVA A NAVEGACAO
		private function travaTela(): void {
			if ((telaAtual + 1) == totalTelas) {
				myRoot.btnAvancar.gotoAndStop(4); //Caso seja á ultima tela do curso ele não libera o Botão Avançar e mostra o estado de trava.
			} else {
				//Trava o Avançar
				myRoot.btnAvancar.gotoAndStop(3);
				myRoot.btnAvancar.buttonMode = false;
				myRoot.btnAvancar.removeEventListener(MouseEvent.MOUSE_DOWN, NextTela);
				myRoot.btnAvancar.removeEventListener(MouseEvent.MOUSE_OUT, NavegaAvancOut);
				myRoot.btnAvancar.removeEventListener(MouseEvent.MOUSE_OVER, NavegaAvancOver);

				//Trava o Voltar
				myRoot.btnVoltar.gotoAndStop(3);
				myRoot.btnVoltar.buttonMode = false;
				myRoot.btnVoltar.removeEventListener(MouseEvent.MOUSE_DOWN, PrevTela);
				myRoot.btnVoltar.removeEventListener(MouseEvent.MOUSE_OUT, NavegaVoltOut);
				myRoot.btnVoltar.removeEventListener(MouseEvent.MOUSE_OVER, NavegaVoltOver);
			}
		}
		
		//### LIBERA A TELA DEPOIS DO TEMPO DETERMINADO
		public function LiberaNavegacao(myTime: Number): void {
			tempoTela = new Timer(myTime * 1000);
			tempoTela.start();
			tempoTela.addEventListener(TimerEvent.TIMER, Navegacao);

			tempoTelaVoltar = new Timer(1500);
			tempoTelaVoltar.start();
			tempoTelaVoltar.addEventListener(TimerEvent.TIMER, NavegacaoVoltar);		
		}

		//### AVANÇAR
		private function Navegacao(event: Event): void {
			myRoot.btnAvancar.gotoAndStop(1);
			myRoot.btnAvancar.buttonMode = true;
			myRoot.btnAvancar.addEventListener(MouseEvent.MOUSE_DOWN, NextTela);
			myRoot.btnAvancar.addEventListener(MouseEvent.MOUSE_OUT, NavegaAvancOut);
			myRoot.btnAvancar.addEventListener(MouseEvent.MOUSE_OVER, NavegaAvancOver);

			tempoTela.stop();
			trace("###-> TELA[" + (telaAtual) + "] LIBERADA");
		}

		//### VOLTAR
		private function NavegacaoVoltar(event: Event): void {
			myRoot.btnVoltar.gotoAndStop(1);
			myRoot.btnVoltar.buttonMode = true;
			myRoot.btnVoltar.addEventListener(MouseEvent.MOUSE_DOWN, PrevTela);
			myRoot.btnVoltar.addEventListener(MouseEvent.MOUSE_OUT, NavegaVoltOut);
			myRoot.btnVoltar.addEventListener(MouseEvent.MOUSE_OVER, NavegaVoltOver);

			tempoTelaVoltar.stop();
		}

		//### AVANÇA TELA
		public function NextTela(event: MouseEvent): void {
			tempoTela.stop();
			tempoTelaVoltar.stop();

			travaTela();
			telaAtual++;
			myRoot.nextFrame();
			if(totalTelas < 10) {
				myRoot.txtTelaAtual.text = "0" + telaAtual;
			} else {
				myRoot.txtTelaAtual.text = telaAtual;
			}

			//LIMPA BOTÕES
			myRoot.btnAvancar.removeEventListener(MouseEvent.MOUSE_DOWN, NextTela);
			myRoot.btnVoltar.removeEventListener(MouseEvent.MOUSE_DOWN, PrevTela);

			LimpaMenus(); //LIMPA MENUS

			//SCORM
			if(telaAtual > telaAtualScorm) {
				frameAtual = myRoot["Tela" + telaAtual].currentFrame;
				ExternalInterface.call("gravaStatus", telaAtual);
				ExternalInterface.call("gravaMyTela", telaAtual,frameAtual);
			}
		}

		//### VOLTA TELA
		private function PrevTela(event: MouseEvent): void {
			tempoTela.stop();
			tempoTelaVoltar.stop();

			travaTela();
			telaAtual--;
			myRoot.prevFrame();
			myRoot.txtTelaAtual.text = telaAtual;

			//LIMPA BOTÕES
			myRoot.btnAvancar.removeEventListener(MouseEvent.MOUSE_DOWN, NextTela);
			myRoot.btnVoltar.removeEventListener(MouseEvent.MOUSE_DOWN, PrevTela);

			LimpaMenus(); //LIMPA MENUS
		}

		//#### ESTADOS DO BOTÃO AVANÇAR
		private function NavegaAvancOver(event: MouseEvent): void {
			if ((telaAtual) == totalTelas) {} else {
				myRoot.btnAvancar.gotoAndStop(2);
			}
		}
		private function NavegaAvancOut(event: MouseEvent): void {
			if ((telaAtual) == totalTelas) {} else {
				myRoot.btnAvancar.gotoAndStop(1);
			}
		}

		//#### ESTADOS DO BOTÃO VOLTAR
		private function NavegaVoltOver(event: MouseEvent): void {
			myRoot.btnVoltar.gotoAndStop(2);
		}
		private function NavegaVoltOut(event: MouseEvent): void {
			myRoot.btnVoltar.gotoAndStop(1);
		}

		//## MENU
		//### CRIA O MENU
		public function MyMenu(): void {
			var NumOpcoes: Number = 0;
			for (var i:Number = 0; i < myRoot.MenuNavegacao.numChildren; i++) {
				var NameMC: String = myRoot.MenuNavegacao.getChildAt(i).name;
				if(NameMC.slice(0,7) == "MenuOp_") {
					//Quando a opção está liberada
					var ControleTelaMenu: Number = ExternalInterface.call("ultimaTela");
					if(ControleTelaMenu >= ConfigMenu[NumOpcoes]) {
						this["myRoot"]["MenuNavegacao"]["MenuOp_" + NumOpcoes].gotoAndStop(1);

						var functionMenuOp: Function = ClickMenu(ConfigMenu[NumOpcoes]);
						this["myRoot"]["MenuNavegacao"]["MenuOp_" + NumOpcoes].buttonMode = true;						
						this["myRoot"]["MenuNavegacao"]["MenuOp_" + NumOpcoes].addEventListener(MouseEvent.CLICK, functionMenuOp);
						
					} else { //Quando a opção está travada					
						this["myRoot"]["MenuNavegacao"]["MenuOp_" + NumOpcoes].gotoAndStop(3);
					}
					NumOpcoes++;
				}
			}
		}

		//### FUNCAO AO CLICAR EM UMA OPCAO
		private function ClickMenu(mcMenu: Number): Function {
			return function (event: Event): void {
				tempoTela.stop();
				tempoTelaVoltar.stop();
				travaTela();

				telaAtual = mcMenu;
				myRoot.txtTelaAtual.text = telaAtual;
						 
				LimpaMenus(); //LIMPA MENUS

				myRoot.gotoAndStop(mcMenu);
			}
		}

		//### LIMPAS OS MENUS ABERTOS AO CLICAR ME UM ITEM DO MENU
		private function LimpaMenus(): void {
			//LIMPA MENUS			 
			if (myRoot.MenuUsuario != undefined) {
				myRoot.MenuUsuario.gotoAndStop(1);
			}
			if (myRoot.MenuNavegacao != undefined) {
				myRoot.MenuNavegacao.gotoAndStop(1);				
			}
			if (myRoot.MenuAjuda != undefined) {
				myRoot.MenuAjuda.gotoAndStop(1);				
			}
			if (myRoot.MenuCredito != undefined) {
				myRoot.MenuCredito.gotoAndStop(1);				
			}
		}

		//## ANIMAÇÕES
		public function MyMovimentoLibera(myMovieClip: MovieClip, myDirection: Array, myAnimation: Object, myDuration: Number, myDelay: Number, myBool: Array, myFunction: Object = ""): void {
			//### ALPHA
			if (myDirection[0] == "a") {
				TweenLite.from(myMovieClip, myDuration, {
					alpha: Number(myDirection[1]) / 100,
					delay: myDelay,
					overwrite: "none"
				});
				TweenLite.to(myMovieClip, myDuration, {
					alpha: Number(myDirection[1]) / 100,
					delay: myDelay,
					overwrite: "none"
				});
				TweenLite.to(myMovieClip, myDuration, {
					alpha: Number(myDirection[2]) / 100,
					delay: myDelay,
					overwrite: "none",
					onComplete: myFunction
				});
			}
			//### VISIBLE
			if (myDirection[0] == "v") {
				TweenLite.to(myMovieClip, myDuration, {
					visible:false,
					onComplete: myFunction
				});
			}
			//### X
			else if (myDirection[0] == "x") {
				TweenMax.from(myMovieClip, myDuration, {
					x: Number(myDirection[1]),
					ease: myAnimation,
					delay: myDelay,
					overwrite: "none"
				});
				TweenMax.to(myMovieClip, myDuration, {
					x: Number(myDirection[2]),
					ease: myAnimation,
					delay: myDelay,
					overwrite: "none",
					onComplete: myFunction
				});
			} 
			//### Y
			else if (myDirection[0] == "y") {
				TweenMax.from(myMovieClip, myDuration, {
					y: Number(myDirection[1]),
					ease: myAnimation,
					delay: myDelay,
					overwrite: "none"
				});
				TweenMax.to(myMovieClip, myDuration, {
					y: Number(myDirection[2]),
					ease: myAnimation,
					delay: myDelay,
					overwrite: "none",
					onComplete: myFunction
				});
			}
			//### SCALE XY
			/*else if (myDirection[0] == "sxy") {
				TweenLite.from(myMovieClip, myDuration, {
					transformAroundCenter: {
						scaleX:myDirection[1], 
						scaleY:myDirection[2]},
					ease: myAnimation,
					overwrite: "none"
				});
				TweenLite.to(myMovieClip, myDuration, {
					transformAroundCenter: {
						scaleX:myDirection[1], 
						scaleY:myDirection[2]},
					ease: myAnimation,
					overwrite: "none",
					onComplete: myFunction
				});
			}*/
			//### GLOW
			else if (myDirection[0] == "gw") {
				TweenMax.from(myMovieClip, myDuration, {
					glowFilter: {
						color:myDirection[1],
						alpha:0, 
						blurX:myDirection[3], 
						blurY:myDirection[4]},
					overwrite: "none"
				});
				TweenMax.to(myMovieClip, myDuration, {
					glowFilter: {
						color:myDirection[1],
						alpha:myDirection[2] / 100, 
						blurX:myDirection[3], 
						blurY:myDirection[4]},
					overwrite: "none",
					onComplete: myFunction
				});
			}
			//### BLUR
			else if (myDirection[0] == "bl") {
				TweenMax.from(myMovieClip, myDuration, {
					blurFilter: {
						blurX:myDirection[1], 
						blurY:myDirection[2],
						quality:myDirection[3],
						remove:myDirection[4]},
					ease: myAnimation,
					overwrite: "none"
				});
				TweenMax.to(myMovieClip, myDuration, {
					blurFilter: {
						blurX:myDirection[1], 
						blurY:myDirection[2],
						quality:myDirection[3],
						remove:myDirection[4]},
					ease: myAnimation,
					overwrite: "none",
					onComplete: myFunction
				});
			}
			//### MOTIONBLUR
			/*else if (myDirection[0] == "mbl") {
				TweenLite.from(myMovieClip, myDuration, {
					x:myDirection[1], 
					y:myDirection[2],
					motionBlur:true,
					ease: myAnimation,
					overwrite: "none"
				});
				TweenLite.to(myMovieClip, myDuration, {
					x:myDirection[1], 
					y:myDirection[2],
					motionBlur:true,
					ease: myAnimation,
					overwrite: "none",
					onComplete: myFunction
				});
			}*/

			//#### LIBERAÇÃO DE TELA APÓS ANIMAÇÃO
			if(myBool[0]) {
				if(myBool[1] == undefined) {
					tempoTela = new Timer(1000 * myDelay);
				} else {
					tempoTela = new Timer(1000 * myBool[1]);
				}
				tempoTela.start();
				tempoTela.addEventListener(TimerEvent.TIMER, Navegacao);

				tempoTelaVoltar = new Timer(1500);
				tempoTelaVoltar.start();
				tempoTelaVoltar.addEventListener(TimerEvent.TIMER, NavegacaoVoltar);
			}
		}		
	}
}