

procedure MultiReaderWaitset.Publisher.Main is


begin
   Particpant := Factory.Create_Participant (Args.DomainId.Get);
   StringTopic1 := Particpant.Create_Topic (Topic_Name => String1_Topic_Name, Type_Name => DDS.String_TypeSupport.Get_Type_Name);
   OctetsTopic1 := Particpant.Create_Topic (Topic_Name => Octets1_Topic_Name, Type_Name => DDS.Octets_TypeSupport.Get_Type_Name);
   StringTopic2 := Particpant.Create_Topic (Topic_Name => String2_Topic_Name, Type_Name => DDS.String_TypeSupport.Get_Type_Name);
   OctetsTopic2 := Particpant.Create_Topic (Topic_Name => Octets2_Topic_Name, Type_Name => DDS.Octets_TypeSupport.Get_Type_Name);


   StringReader1 := Particpant.Create_DataReader (StringTopic1);
   StringReader2 := Particpant.Create_DataReader (StringTopic2);
   OctetsReader1 := Particpant.Create_DataReader (OctetsTopic1);
   OctetsReader2 := Particpant.Create_DataReader (OctetsTopic2);


   Particpant.Enable;

   Particpant.Delete_DataReader (StringReader1);
   Particpant.Delete_DataReader (StringReader2);
   Particpant.Delete_DataReader (OctetsReader1);
   Particpant.Delete_DataReader (OctetsReader2);
   Particpant.Delete_Topic (StringTopic1);
   Particpant.Delete_Topic (StringTopic2);
   Particpant.Delete_Topic (OctetsTopic1);
   Particpant.Delete_Topic (OctetsTopic2);
end MultiReaderWaitset.Publisher.Main;
