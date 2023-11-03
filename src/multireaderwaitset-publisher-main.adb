with DDS.DataWriter;
with MultiReaderWaitset.Args;
with DDS.String_TypeSupport;
with DDS.Octets_TypeSupport;
with MultiReaderWaitset.Topic_Names; use MultiReaderWaitset.Topic_Names;

procedure MultiReaderWaitset.Publisher.Main is
   D1 : constant DDS.String := DDS.To_DDS_String ("D1");
   D2 : constant DDS.String := DDS.To_DDS_String ("D2");

   O1_Data : Standard.String := "O1";
   O2_Data : Standard.String := "O1";
   O1      : constant DDS.Octets := DDS.Octets'(Length => 2, Value => O1_Data'Address);
   O2      : constant DDS.Octets := DDS.Octets'(Length => 2, Value => O2_Data'Address);
begin
   if Args.Parser.Parse then
      Particpant := Factory.Create_Participant (Args.DomainId.Get);
      StringTopic1 := Particpant.Create_Topic (Topic_Name => String1_Topic_Name, Type_Name => DDS.String_TypeSupport.Get_Type_Name);
      OctetsTopic1 := Particpant.Create_Topic (Topic_Name => Octets1_Topic_Name, Type_Name => DDS.Octets_TypeSupport.Get_Type_Name);
      StringTopic2 := Particpant.Create_Topic (Topic_Name => String2_Topic_Name, Type_Name => DDS.String_TypeSupport.Get_Type_Name);
      OctetsTopic2 := Particpant.Create_Topic (Topic_Name => Octets2_Topic_Name, Type_Name => DDS.Octets_TypeSupport.Get_Type_Name);

      StringWriter1 := DDS.String_DataWriter.Ref_Access (Particpant.Create_DataWriter (StringTopic1));
      StringWriter2 := DDS.String_DataWriter.Ref_Access (Particpant.Create_DataWriter (StringTopic2));
      OctetsWriter1 := DDS.Octets_DataWriter.Ref_Access (Particpant.Create_DataWriter (OctetsTopic1));
      OctetsWriter2 := DDS.Octets_DataWriter.Ref_Access (Particpant.Create_DataWriter (OctetsTopic2));
      delay 1.0;
      StringWriter1.Write (D1, DDS.Null_InstanceHandle_T);
      StringWriter2.Write (D2, DDS.Null_InstanceHandle_T);
      OctetsWriter1.Write (O1, DDS.Null_InstanceHandle_T);
      OctetsWriter2.Write (O2, DDS.Null_InstanceHandle_T);
      delay 1.0;

      Particpant.Delete_DataWriter (DDS.Datawriter.Ref_Access (StringWriter1));
      Particpant.Delete_DataWriter (DDS.Datawriter.Ref_Access (StringWriter2));
      Particpant.Delete_DataWriter (DDS.Datawriter.Ref_Access (OctetsWriter1));
      Particpant.Delete_DataWriter (DDS.Datawriter.Ref_Access (OctetsWriter2));
      Particpant.Delete_Topic (StringTopic1);
      Particpant.Delete_Topic (StringTopic2);
      Particpant.Delete_Topic (OctetsTopic1);
      Particpant.Delete_Topic (OctetsTopic2);
   end if;
end MultiReaderWaitset.Publisher.Main;
