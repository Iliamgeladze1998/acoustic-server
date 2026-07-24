package mx.controls.dataGridClasses
{
   import mx.controls.listClasses.BaseListData;
   import mx.core.IUIComponent;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class DataGridListData extends BaseListData
   {
      
      mx_internal static const VERSION:String = "4.5.1.21328";
      
      [Bindable("__NoChangeEvent__")]
      public var dataField:String;
      
      public function DataGridListData(text:String, dataField:String, columnIndex:int, uid:String, owner:IUIComponent, rowIndex:int = 0)
      {
         super(text,uid,owner,rowIndex,columnIndex);
         this.dataField = dataField;
      }
   }
}

