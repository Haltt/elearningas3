/**
 * @package PreLoader
 * @copyright Wanderson Teixeira (wandersonteixeira@live.com)
 * @created 29/12/2014
 * @version 1.0.0.0, 29/12/2014
 * @internal Classe principal, onde está tratado a navegação e funcionalidades padrões.
 **/

package {
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.ProgressEvent;
	import flash.utils.getDefinitionByName;
	
	import flash.external.*;

	public class PreLoader extends MovieClip {
		private var myRootPre: Object; //Define o Root
		
		private var TelaArmazenada:Number = 0;
		private var PorcentagemLoader:Number = 0;
		
		private var lessonStatus:String;
		private var lmsConnected:Boolean;
		private var lmsSuccess:Boolean;
		
		
		public function PreLoader()
		{
			myRootPre = MovieClip(root);
			//if(stage)
			//{			
				//this.loaderInfo.addEventListener(ProgressEvent.PROGRESS, CarregadorLoader);
				//ExternalInterface.call("trapallkeys", true);
			//}
			
			lmsConnected = Boolean(ExternalInterface.call("SCOInitialize"));
			//trace(lmsConnected);
			if(lmsConnected)
			{
				//lessonStatus = ExternalInterface.call("g_bInitDone");
				ExternalInterface.call("alert",lmsConnected);
			}
			else
			{
				trace("Could not connect to LMS.");
			}
		}
	 
		private function CarregadorLoader(e: ProgressEvent): void 
		{
			PorcentagemLoader = Math.round(e.bytesLoaded / e.bytesTotal * 100);
			if (PorcentagemLoader == 100) 
			{
				this.loaderInfo.removeEventListener(ProgressEvent.PROGRESS, CarregadorLoader);
				ScormFunction();
			}
		}
	
		private function ScormFunction(): void 
		{			
			if (MovieClip(root).api != null && MovieClip(root).api == "D27CDB6EAE6D11cf96B8444553540000") 
			{
				trace("SCORM");
				TelaArmazenada = Number(MovieClip(root).locationTela);
				this.gotoAndStop(2);
			} 
			else 
			{
				trace("Este conteúdo deve ser visualizado na plataforma LMS da empresa.");
			}
		}
	}
}