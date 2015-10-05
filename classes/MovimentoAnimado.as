/**
 * @package MovimentoAnimado
 * @copyright Wanderson Teixeira (wandersonteixeira@live.com)
 * @created 03/11/2014
 * @version 1.0.0.0, 26/12/2014
 * @internal Classe que trata as animações de entrada de objetos.
 **/

package {
	import flash.utils.*;
	import flash.events.*;
	import flash.display.*;

	import com.greensock.*;
	import com.greensock.easing.*;

	public class MovimentoAnimado extends MovieClip {
		private var myRoot: Object; //Define o Root
		private var myParent: Object; //Define o Parent

		public function MovimentoAnimado() {
			addEventListener(Event.ADDED, beginClass);
		}

		private function beginClass(event: Event): void {
			myRoot = MovieClip(root);
			myParent = MovieClip(parent);
		}

		public function MyMovimento(myMovieClip: MovieClip, myDirection: Array, myAnimation: Object, myDuration: Number, myDelay: Number, myBool: Boolean = false, myFunction: Object = ""): void {
			//ALPHA
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
			//X
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
			//Y
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
		}
	}

}