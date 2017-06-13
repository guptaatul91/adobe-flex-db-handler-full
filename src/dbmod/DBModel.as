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
	
	import dbmod.DBController;
	
	import flash.data.SQLConnection;
	import flash.filesystem.File;
	import flash.net.FileReference;
	import flash.system.Capabilities;
		
	public class DBModel
	{
		private static var _dbModel:DBModel = null ;
		private var _dbController :DBController = null ;
		private var _dbConn :SQLConnection = null ;
		private var _dbFilePath :String = "" ;
		/**************
		 * Constructor 
		 *************/
		public function DBModel()
		{
			if(_dbModel!=null) throw new Error("only single instance of db model allowed.");
		}
		public function set dbConn(dbConn:SQLConnection):void 
		{
			this._dbConn = dbConn ;
		}
		public function get dbConn():SQLConnection 
		{
			return this._dbConn ; 
				
		}
		public function get dbFilePath():String
		{
			return this._dbFilePath ;
		}
		/**** DBController Instance *****/
		public function set dbController(dbController:DBController):void
		{
			this._dbController = dbController ;
		}
		
		public function get dbController():DBController
		{
			return this._dbController ;
		}
		
		/***************************************
		 * 
		 *  file should be inside <b>assets/db<b></br> 
		 * in application root</br> 
		 * 
		 *  No trailing with path 
		 * 
		 * dbFileName should be with extension 
		 * *******************************************/
		
		public function copyDBToLSByPath(dbFileName :String):Boolean
		{
			trace("Make a Copy of DB") ;
			try
			{
				var dbFileCopy :File = File.applicationStorageDirectory.resolvePath("db"+File.separator+dbFileName) ;
				var dbFile :File= File.applicationDirectory.resolvePath("assets"+File.separator+"db"+File.separator+dbFileName) ;
				if(!dbFileCopy.exists)
				{
					if(dbFile.exists)
					{
						dbFile.copyTo(dbFileCopy as FileReference);
						//dbModel.dbFilePath = ApplicationCores.getNativePath(dbFileCopy.nativePath);
						
						_dbFilePath = getNativePath(dbFileCopy.nativePath);
					}
					else
					{
						//Alert.show("DataBase file is not exist !!!!","File Not Found");
						throw new Error("Database file is not exist!");
						//return ;
					}
				}
				else
				{
					_dbFilePath = getNativePath(dbFileCopy.nativePath);
				}
				
				return true  ;
			}
			catch(err:Error)
			{
				trace(" File Not Found: "+err.message);
			}
			return false  ; 
		}
		private  function getNativePath(path:String):String
		{
			if(Capabilities.os.indexOf("Windows") == -1)
			{
				path = "file://"+path ;
			}
			return path ;
		}
		
		/*** DBModel single instance *****/
		
		
		public static function getInstance():DBModel 
		{
			if(_dbModel == null)
			{
				_dbModel = new DBModel();
			}
			return _dbModel ;
		}
		
		
		
	}
}