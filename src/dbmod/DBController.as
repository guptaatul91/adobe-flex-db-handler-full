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
	import flash.data.SQLConnection;
	import flash.data.SQLMode;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.SQLErrorEvent;
	import flash.events.SQLEvent;
	import flash.filesystem.File;
	
	import mx.controls.Alert;

	public class DBController  extends Sprite
	{
		
		private var dbModel :DBModel = DBModel.getInstance();
		//private var sqlConn :SQLConnection= null ; 
		private var main :DisplayObject = null ; // MAin Application Instance Variable
		//private var callBack:Function ;
		public function DBController(main:DisplayObject)
		{
			this.main = main ;
		}
		
		public function openDBConnection(dbMode :String="create",isAsync:Boolean = true):void
		{
			trace("Open Database Connection");
			//this.callBack = callBack ;
			dbModel.dbConn = new SQLConnection();
			var dbFilePath :String = dbModel.dbFilePath ;
			if(dbFilePath =="") 
			{
				Alert.show("No Database file Exist","DBError");
				return  ;
			}
			
			var dbFile:File = new File(dbModel.dbFilePath);
			if(isAsync)
			{
				switch(dbMode.toLowerCase())
				{
					case "create":
						dbModel.dbConn.openAsync(dbFile,SQLMode.CREATE);
						break;
					case "read" :
						dbModel.dbConn.openAsync(dbFile,SQLMode.READ)
						break;
					case "update" :
						dbModel.dbConn.openAsync(dbFile,SQLMode.UPDATE);
						break;
				}
			}
			else
			{
				switch(dbMode)
				{
					case "create":
						dbModel.dbConn.open(dbFile,SQLMode.CREATE);
						break;
					case "read" :
						dbModel.dbConn.open(dbFile,SQLMode.READ)
						break;
					case "update" :
						dbModel.dbConn.open(dbFile,SQLMode.UPDATE);
						break;
				}
			}
			dbModel.dbConn.addEventListener(SQLEvent.OPEN,openDBHandler);
			dbModel.dbConn.addEventListener(SQLErrorEvent.ERROR, errorOpenDBHandler);
		}
		
		protected function errorOpenDBHandler(event:SQLErrorEvent):void
		{
			trace("Error message:", event.error.message); 
			trace("Details:", event.error.details); 
			var data :Object =  {
				message : event.error.message ,
				details : event.error.details 
			}
			dispatchEvent(new DBEvent(DBEvent.DB_CONN_FAIL,false,false,data));
		}
		
		protected function openDBHandler(event:SQLEvent):void
		{ 
			trace("Open Database Connection Successfully");
			dispatchEvent(new DBEvent(DBEvent.DB_CONN_SUCCESSFUL));
		}
		
		public function removeDBEvent(dbHandler:DBHandler,func:Function):void
		{
			dbHandler.removeEventListener(DBEvent.DB_RESULT_GET ,func);
		}
	
		
	}
}