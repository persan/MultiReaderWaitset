with Ada.Text_IO;
package body MultiReaderWaitset.Subscriper is
   overriding procedure On_Data_Available
     (Self       : not null access Listner;
      The_Reader : in DDS.DataReaderListener.DataReader_Access) is
   begin
      DDS.DataReaderListener.Ref_Access (Self).On_Data_Available (The_Reader);
      Ada.Text_IO.Put_Line (Self.Name.all);
   end;

end MultiReaderWaitset.Subscriper;
