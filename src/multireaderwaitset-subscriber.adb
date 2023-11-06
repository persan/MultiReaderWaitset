with Ada.Text_IO;
with Dds.Octets_DataReader;
with Dds.String_DataReader;
with GNAT.Source_Info;

package body MultiReaderWaitset.Subscriber is

   overriding procedure On_Data_Available
     (Self       : not null access String_Listner;
      The_Reader : in DDS.DataReaderListener.DataReader_Access) is
   begin
      for I of Dds.String_DataReader.Ref_Access (The_Reader).Read loop
         Self.Server.On_String (Self.Name.all, I.Data.all);
      end loop;
   end;

   overriding procedure On_Data_Available
     (Self       : not null access Octets_Listner;
      The_Reader : in DDS.DataReaderListener.DataReader_Access) is
   begin
      for I of Dds.Octets_DataReader.Ref_Access (The_Reader).Read loop
         Self.Server.On_Octets (Self.Name.all, I.Data.all);
      end loop;
   end;

   task body Server_Type is

   begin
      while Continue loop
         select
            accept On_String (Name : String; Data : DDS.String) do
               Ada.Text_IO.Put_Line (Name & ":" & GNAT.Source_Info.Enclosing_Entity & ":" & Dds.To_Standard_String (Data));
            end On_String;
         or
            accept On_Octets (Name : String; Data : DDS.Octets) do
               Ada.Text_IO.Put_Line (Name & ":" & GNAT.Source_Info.Enclosing_Entity & ":" & Data.Length'Image & "/" & String (Octets_As_String (Data)));
            end On_Octets;
         or
            accept Close;
            Continue := False;
         or
            terminate;
         end select;
      end loop;
   end Server_Type;

end MultiReaderWaitset.Subscriber;
