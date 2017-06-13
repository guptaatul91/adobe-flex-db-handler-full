/***********************************************
 *    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    
 *    @@@	        Developer Profile        @@@    
 *    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    
 *    @ Name 		  : Atul Kumar Gupta 	   @
 *    @ Creation Date : 7-July 2015      	   @
 *    @ Email Id 	  : guptaatul91@gmail.com  @
 * 	  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
 * *********************************************/


package dbmod
{
	import flash.events.Event;
	
	public class DBEvent extends Event
	{
		public static const DB_CONN_SUCCESSFUL :String  = "dbconnsuccessful" ;
		public static const DB_RESULT_GET :String  = "dbresultget" ;
		public static const DB_CONN_FAIL :String  = "dbconnfail" ;
		private var _data:Object= null;
		public function DBEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false,data:Object=null)
		{
			super(type, bubbles, cancelable);
			this._data = data ;
		}
		
		public function get data():Object
		{
			return this._data;	
		}
		override public function get bubbles():Boolean
		{
			// TODO Auto Generated method stub
			return super.bubbles;
		}
		
		override public function get cancelable():Boolean
		{
			// TODO Auto Generated method stub
			return super.cancelable;
		}
		
		override public function clone():Event
		{
			// TODO Auto Generated method stub
			return super.clone();
		}
		
		override public function get currentTarget():Object
		{
			// TODO Auto Generated method stub
			return super.currentTarget;
		}
		
		override public function get eventPhase():uint
		{
			// TODO Auto Generated method stub
			return super.eventPhase;
		}
		
		override public function formatToString(className:String, ...parameters):String
		{
			// TODO Auto Generated method stub
			return super.formatToString(className, parameters);
		}
		
		override public function isDefaultPrevented():Boolean
		{
			// TODO Auto Generated method stub
			return super.isDefaultPrevented();
		}
		
		override public function preventDefault():void
		{
			// TODO Auto Generated method stub
			super.preventDefault();
		}
		
		override public function stopImmediatePropagation():void
		{
			// TODO Auto Generated method stub
			super.stopImmediatePropagation();
		}
		
		override public function stopPropagation():void
		{
			// TODO Auto Generated method stub
			super.stopPropagation();
		}
		
		override public function get target():Object
		{
			// TODO Auto Generated method stub
			return super.target;
		}
		
		override public function toString():String
		{
			// TODO Auto Generated method stub
			return super.toString();
		}
		
		override public function get type():String
		{
			// TODO Auto Generated method stub
			return super.type;
		}
		
	}
}