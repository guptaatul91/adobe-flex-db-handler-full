/***********************************************
 *    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    
 *    @@@	        Developer Profile        @@@    
 *    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    
 *    @ Name 		  : Atul Kumar Gupta 	   @
 *    @ Creation Date : 7-July 2015      	   @
 *    @ Updated Date n: 22-Jan 2016      	   @
 *    @ Email Id 	  : guptaatul91@gmail.com  @
 * 	  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
 * *********************************************/

package dbmod
{
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.display.Sprite;
	import flash.events.SQLErrorEvent;
	import flash.events.SQLEvent;
	
	import mx.collections.ArrayCollection;

	public class DBHandler extends Sprite
	{
		private var dbModel :DBModel = DBModel.getInstance();
		private var operation:String="";
		public function DBHandler(operation:String="")
		{
			this.operation = operation;
		}
		public function executeDBStmt(query :String):void
		{
			var stmt:SQLStatement = new SQLStatement(); 
			stmt.sqlConnection = dbModel.dbConn; 
			stmt.text = query; 
			stmt.addEventListener(SQLEvent.RESULT, getResult); 
			stmt.addEventListener(SQLErrorEvent.ERROR, errorGetResult); 
			stmt.execute(); 
		}
		
		/**
		 **************************************************
		 * 
		 * Columns contains Objects of Two key value pairs</br>
		 * First is Column name , Second is Column Type </br>
		 *  Column Type :  TEXT , NUMERIC ,INTEGER ,BLOB 
		 * ,int , string </br>
		 * </br>
		 * <p>
		 * EXAMPLE : --</br>
		 * var columns:Array= </br>
		 * [</br>
				{"name":"COLUMN1","type":""},</br>
				{"name":"COLUMN2","type":"int"}</br>
		   ]
		 *</br></br>
		 * var tblName :String =  "TABLE_NAME" ; </br>
		 * var dataColl :ArrayCollection = new ArrayCollection(</br>
		 * [</br>
		 * 		{COLUMN1:value1,COLUMN2:value2},</br>
		 * 		{COLUMN1:value1,COLUMN2:value2},</br>
		 * 		{COLUMN1:value1,COLUMN2:value2}</br>
		 * ])</br>
		 * </br>
		 * </p>
		 * 
		 **************************************************
		 * */
		
		public function bulkExecuteDBStmt(tblName:String,columns:Array ,dataColl:ArrayCollection):Boolean
		{
			var isSuccess :Boolean = false  ;
			switch(this.operation)
			{
				case "INSERT" :
					isSuccess = bulkInsert(tblName,columns,dataColl);
					break ;
			}
			return isSuccess
		}
		
		private function bulkInsert(tblName:String, columns:Array, dataColl:ArrayCollection):Boolean
		{
			try
			{
				var saveStmt:SQLStatement = new SQLStatement();         
				saveStmt.sqlConnection = dbModel.dbConn; 
				var columnsStr:String = "";
				var valueStr :String = "" ;
				
				for(var iCol:int =0 ;iCol<columns.length;iCol++)
				{
					columnsStr +=  columns[iCol].name+"," ;
					valueStr += "?,"
				}
				if(columnsStr !="")
				{
					columnsStr = columnsStr.substr(0,columnsStr.length-1);
					valueStr = valueStr.substr(0,valueStr.length-1);
				}
				
				var sqlQuery :String = "insert into "+tblName+"("+columnsStr+") values("+valueStr+")";
				
				dbModel.dbConn.begin();           
				 
				for (var i:int = 0; i < dataColl.length; i++)
				{
					saveStmt = new SQLStatement();
					
					saveStmt.sqlConnection = dbModel.dbConn;
					saveStmt.text = sqlQuery;
					
					for(var indexColumn:int=0;indexColumn<columns.length ;indexColumn++)
					{
						var columnObj:Object = columns[indexColumn] ; 
						switch(columnObj.type.toString().toUpperCase())
						{
							case "NUMERIC" :
								saveStmt.parameters[indexColumn] = int(dataColl.getItemAt(i)[columnObj.name]) ;
								break ;
							case "INTEGER" :
								saveStmt.parameters[indexColumn] = int(dataColl.getItemAt(i)[columnObj.name]) ;
								break ;
							case "INT" :
								saveStmt.parameters[indexColumn] = Number(dataColl.getItemAt(i)[columnObj.name.toString()]) ;
								break ;
							case "TEXT" :
								saveStmt.parameters[indexColumn] = String(dataColl.getItemAt(i)[columnObj.name]) ;
								break;
							case "STRING" :
								saveStmt.parameters[indexColumn] = String(dataColl.getItemAt(i)[columnObj.name]) ;
								break;
						}
						
					}
					
					saveStmt.execute();

				}
				dbModel.dbConn.commit();
			
				saveStmt = null;
				
				return true  ;
			}
			catch(error:Error)
			{
				//dbModel.dbConn.rollback();
				trace(error.message);
				
			}
			return false ;
		}
		
		protected function errorGetResult(event:SQLErrorEvent):void
		{
			var stmt:SQLStatement = event.currentTarget as SQLStatement ;
			this.removeSQLStmtEvents(stmt);
			
			trace("Error : "+event.error +"\n"+"Error Details : "+event.error.details);
		}

		protected function getResult(event:SQLEvent):void
		{
			var stmt:SQLStatement = event.currentTarget as SQLStatement ;
			this.removeSQLStmtEvents(stmt);
			var result:SQLResult = stmt.getResult(); 
			if(this.operation =="INSERT")
			{
				if(stmt.sqlConnection != null)
				{
					var insertRes :Object = 
						{
							lastInsertRowID :stmt.sqlConnection.lastInsertRowID 
						}
				}
				dispatchEvent(new DBEvent(DBEvent.DB_RESULT_GET,false,false,insertRes));	
			}
			else
			{
				dispatchEvent(new DBEvent(DBEvent.DB_RESULT_GET,false,false,result.data));	
			}
		}
		
		
		
		private function removeSQLStmtEvents(stmt:SQLStatement):void
		{
			stmt.removeEventListener(SQLEvent.RESULT,getResult);
			stmt.removeEventListener(SQLErrorEvent.ERROR, errorGetResult); 
		}
	}
}