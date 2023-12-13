with DDS.DataWriter;
with MultiReaderWaitset.Args;
with DDS.String_TypeSupport;
with DDS.Octets_TypeSupport;
with MultiReaderWaitset.Topic_Names; use MultiReaderWaitset.Topic_Names;

procedure MultiReaderWaitset.Publisher.Main is

   D1 : constant DDS.String := DDS.To_DDS_String ("D1");
   D2 : constant DDS.String := DDS.To_DDS_String ("D2");

   O1_Data : aliased constant String_8 := "O1_Data" & ASCII.NUL;
   O2_Data : aliased constant String_8 := "O2_Data" & ASCII.NUL;

   O1      : constant DDS.Octets := String_As_Octets (O1_Data'Unchecked_Access);
   O2      : constant DDS.Octets := String_As_Octets (O2_Data'Unchecked_Access);

begin
   if Args.Parser.Parse then
      Particpant := Factory.Create_Participant_With_Profile (Args.DomainId.Get, Args.Library.Get.all, Args.Profile.Get.all);

      StringTopic1 := Particpant.Create_Topic_With_Profile (String1_Topic_Name, DDS.String_TypeSupport.Get_Type_Name, Args.Library.Get.all, Args.Profile.Get.all);
      OctetsTopic1 := Particpant.Create_Topic_With_Profile (Octets1_Topic_Name, DDS.Octets_TypeSupport.Get_Type_Name, Args.Library.Get.all, Args.Profile.Get.all);
      StringTopic2 := Particpant.Create_Topic_With_Profile (String2_Topic_Name, DDS.String_TypeSupport.Get_Type_Name, Args.Library.Get.all, Args.Profile.Get.all);
      OctetsTopic2 := Particpant.Create_Topic_With_Profile (Octets2_Topic_Name, DDS.Octets_TypeSupport.Get_Type_Name, Args.Library.Get.all, Args.Profile.Get.all);

      StringWriter1 := DDS.String_DataWriter.Ref_Access (Particpant.Create_DataWriter_With_Profile (StringTopic1, Args.Library.Get.all, Args.Profile.Get.all));
      StringWriter2 := DDS.String_DataWriter.Ref_Access (Particpant.Create_DataWriter_With_Profile (StringTopic2, Args.Library.Get.all, Args.Profile.Get.all));
      OctetsWriter1 := DDS.Octets_DataWriter.Ref_Access (Particpant.Create_DataWriter_With_Profile (OctetsTopic1, Args.Library.Get.all, Args.Profile.Get.all));
      OctetsWriter2 := DDS.Octets_DataWriter.Ref_Access (Particpant.Create_DataWriter_With_Profile (OctetsTopic2, Args.Library.Get.all, Args.Profile.Get.all));

      StringWriter1.Wait (DDS.PUBLICATION_MATCH_STATUS, 10.0);
      StringWriter2.Wait (DDS.PUBLICATION_MATCH_STATUS, 10.0);
      OctetsWriter1.Wait (DDS.PUBLICATION_MATCH_STATUS, 10.0);
      OctetsWriter2.Wait (DDS.PUBLICATION_MATCH_STATUS, 10.0);

      StringWriter1.Write (D1, DDS.Null_InstanceHandle_T);
      StringWriter2.Write (D2, DDS.Null_InstanceHandle_T);
      OctetsWriter1.Write (O1, DDS.Null_InstanceHandle_T);
      OctetsWriter2.Write (O2, DDS.Null_InstanceHandle_T);
      delay Args.Execution_Time.Get;

      Particpant.Delete_DataWriter (DDS.Datawriter.Ref_Access (StringWriter1));
      Particpant.Delete_DataWriter (DDS.Datawriter.Ref_Access (StringWriter2));
      Particpant.Delete_DataWriter (DDS.Datawriter.Ref_Access (OctetsWriter1));
      Particpant.Delete_DataWriter (DDS.Datawriter.Ref_Access (OctetsWriter2));
      Particpant.Delete_Topic (StringTopic1);
      Particpant.Delete_Topic (StringTopic2);
      Particpant.Delete_Topic (OctetsTopic1);
      Particpant.Delete_Topic (OctetsTopic2);
      Particpant.Delete_Contained_Entities;
      Factory.Delete_Participant (Particpant);
   end if;
end MultiReaderWaitset.Publisher.Main;
