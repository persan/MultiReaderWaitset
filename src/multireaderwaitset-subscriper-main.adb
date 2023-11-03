with MultiReaderWaitset.Args;
with DDS.String_TypeSupport;
with DDS.Octets_TypeSupport;

with MultiReaderWaitset.Topic_Names; use MultiReaderWaitset.Topic_Names;
with GNAT.Ctrl_C;
procedure MultiReaderWaitset.Subscriper.Main is
   Participant_QoS : DDS.DomainParticipantQos;
   Continue        : Boolean := True;
   procedure On_Ctrl_C is
   begin
      Continue := False;
      Ada.Text_Io.Standard_Output.Put_Line ("On <Ctrl-C>");
   end On_Ctrl_C;
begin
   GNAT.Ctrl_C.Install_Handler (On_Ctrl_C'Unrestricted_Access);
   Factory.Get_Default_Participant_Qos (Participant_QoS);
   Participant_QoS.Entity_Factory.Autoenable_Created_Entities := False;

   Particpant := Factory.Create_Participant (Args.DomainId.Get);

   StringTopic1 := Particpant.Create_Topic (Topic_Name => String1_Topic_Name, Type_Name => DDS.String_TypeSupport.Get_Type_Name);
   OctetsTopic1 := Particpant.Create_Topic (Topic_Name => Octets1_Topic_Name, Type_Name => DDS.Octets_TypeSupport.Get_Type_Name);
   StringTopic2 := Particpant.Create_Topic (Topic_Name => String2_Topic_Name, Type_Name => DDS.String_TypeSupport.Get_Type_Name);
   OctetsTopic2 := Particpant.Create_Topic (Topic_Name => Octets2_Topic_Name, Type_Name => DDS.Octets_TypeSupport.Get_Type_Name);

   -- Create the readers with a listner but no callbacke enabled.
   StringReader1 := Particpant.Create_DataReader (StringTopic1, A_Listener => String1_Listner'Access);
   StringReader2 := Particpant.Create_DataReader (StringTopic2, A_Listener => String2_Listner'Access);
   OctetsReader1 := Particpant.Create_DataReader (OctetsTopic1, A_Listener => Octets1_Listner'Access);
   OctetsReader2 := Particpant.Create_DataReader (OctetsTopic2, A_Listener => Octets2_Listner'Access);



   Particpant.Enable;


   while Continue loop
      delay 0.1;
   end loop;

   Particpant.Delete_DataReader (StringReader1);
   Particpant.Delete_DataReader (StringReader2);
   Particpant.Delete_DataReader (OctetsReader1);
   Particpant.Delete_DataReader (OctetsReader2);
   Particpant.Delete_Topic (StringTopic1);
   Particpant.Delete_Topic (StringTopic2);
   Particpant.Delete_Topic (OctetsTopic1);
   Particpant.Delete_Topic (OctetsTopic2);
end MultiReaderWaitset.Subscriper.Main;
