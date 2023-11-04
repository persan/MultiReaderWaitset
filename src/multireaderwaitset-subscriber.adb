with Ada.Text_IO;
with Dds.Octets_DataReader;
with Dds.String_DataReader;

package body MultiReaderWaitset.Subscriber is
   overriding procedure On_Data_Available
     (Self       : not null access String_Listner;
      The_Reader : in DDS.DataReaderListener.DataReader_Access) is
   begin
      Ada.Text_IO.Put_Line (Self.Name.all);
      for I of Dds.String_DataReader.Ref_Access (The_Reader).Read loop
         Ada.Text_IO.Put_Line (DDS.To_Standard_String (I.Data.all));
      end loop;
   end;

   overriding procedure On_Data_Available
     (Self       : not null access Octets_Listner;
      The_Reader : in DDS.DataReaderListener.DataReader_Access) is
   begin
      Ada.Text_IO.Put_Line (Self.Name.all);
      for I of Dds.Octets_DataReader.Ref_Access (The_Reader).Read loop
         Ada.Text_IO.Put_Line (I.Data.all'Image);
      end loop;
   end;

end MultiReaderWaitset.Subscriber;
