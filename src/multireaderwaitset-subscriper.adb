with Ada.Text_IO;
with DDS.ReadCondition;
package body MultiReaderWaitset.Subscriper is
   overriding procedure On_Data_Available
     (Self       : not null access Listner;
      The_Reader : in DDS.DataReaderListener.DataReader_Access) is
   begin
      DDS.DataReaderListener.Ref_Access (Self).On_Data_Available (The_Reader);
      Ada.Text_IO.Put_Line (Self.Name.all);
   end;
   procedure On_Condition (Self      : not null access Listner;
                           Condition : aliased  DDS.Condition.Ref'Class) is
   begin
      if Condition'Class = DDS.ReadCondition.Ref then
         declare
            Reader : Dds.DataReader.Ref_Access := DDS.ReadCondition.Ref_Access (Condition).Get_Datareader;
         begin
            null;
         end;
      end if;
   end;

end MultiReaderWaitset.Subscriper;
