with Ada.Text_IO; use Ada.Text_IO;
with DDS.Condition;
with MultiReaderWaitset.Args;
with DDS.String_TypeSupport;
with DDS.Octets_TypeSupport;
with Dds.ConditionSeq;
with MultiReaderWaitset.Topic_Names; use MultiReaderWaitset.Topic_Names;
with GNAT.Ctrl_C;
with Ada.Tags;

procedure MultiReaderWaitset.Subscriber.Main is
   use type DDS.StatusKind;

   procedure On_Ctrl_C is
   begin
      Continue := False;
      Server.Close;
      Ada.Text_Io.Standard_Output.Put_Line ("On <Ctrl-C>");
   end On_Ctrl_C;

   Conditions      : aliased Dds.ConditionSeq.Sequence;
   ERROR_STATUSES  : constant DDS.StatusKind :=
                       DDS.INCONSISTENT_TOPIC_STATUS or
                           DDS.REQUESTED_DEADLINE_MISSED_STATUS or
                               DDS.REQUESTED_INCOMPATIBLE_QOS_STATUS or
                                   DDS.SAMPLE_LOST_STATUS or
                                       DDS.SAMPLE_REJECTED_STATUS or
                                           DDS.LIVELINESS_LOST_STATUS;
   Reader          : DDS.Datareader.Ref_Access;
begin
   if Args.Parser.Parse then

      GNAT.Ctrl_C.Install_Handler (On_Ctrl_C'Unrestricted_Access);

      --  --------------------------
      --  Build the DDS application.
      --  --------------------------
      Particpant := Factory.Create_Participant_With_Profile (Args.DomainId.Get, Args.Library.Get.all, Args.Profile.Get.all);

      StringTopic1 := Particpant.Create_Topic_With_Profile (String1_Topic_Name, DDS.String_TypeSupport.Get_Type_Name, Args.Library.Get.all, Args.Profile.Get.all);
      OctetsTopic1 := Particpant.Create_Topic_With_Profile (Octets1_Topic_Name, DDS.Octets_TypeSupport.Get_Type_Name, Args.Library.Get.all, Args.Profile.Get.all);
      StringTopic2 := Particpant.Create_Topic_With_Profile (String2_Topic_Name, DDS.String_TypeSupport.Get_Type_Name, Args.Library.Get.all, Args.Profile.Get.all);
      OctetsTopic2 := Particpant.Create_Topic_With_Profile (Octets2_Topic_Name, DDS.Octets_TypeSupport.Get_Type_Name, Args.Library.Get.all, Args.Profile.Get.all);

      --  Create the readers with a listner but no callbacks enabled.
      --  The listner will be retrived from the from the reader in the ReadCondition.
      StringReader1 := Particpant.Create_DataReader_With_Profile (StringTopic1.As_TopicDescription, Args.Library.Get.all, Args.Profile.Get.all, String1_Listner'Access, ERROR_STATUSES);
      StringReader2 := Particpant.Create_DataReader_With_Profile (StringTopic2.As_TopicDescription, Args.Library.Get.all, Args.Profile.Get.all, String2_Listner'Access, ERROR_STATUSES);
      OctetsReader1 := Particpant.Create_DataReader_With_Profile (OctetsTopic1.As_TopicDescription, Args.Library.Get.all, Args.Profile.Get.all, Octets1_Listner'Access, ERROR_STATUSES);
      OctetsReader2 := Particpant.Create_DataReader_With_Profile (OctetsTopic2.As_TopicDescription, Args.Library.Get.all, Args.Profile.Get.all, Octets2_Listner'Access, ERROR_STATUSES);

      --  Build the wait-set.
      Ws.Attach_Condition (StringReader1.Create_Readcondition (DDS.NOT_READ_SAMPLE_STATE, DDS.ANY_VIEW_STATE, DDS.ALIVE_INSTANCE_STATE));
      Ws.Attach_Condition (StringReader2.Create_Readcondition (DDS.NOT_READ_SAMPLE_STATE, DDS.ANY_VIEW_STATE, DDS.ALIVE_INSTANCE_STATE));
      Ws.Attach_Condition (OctetsReader1.Create_Readcondition (DDS.NOT_READ_SAMPLE_STATE, DDS.ANY_VIEW_STATE, DDS.ALIVE_INSTANCE_STATE));
      Ws.Attach_Condition (OctetsReader2.Create_Readcondition (DDS.NOT_READ_SAMPLE_STATE, DDS.ANY_VIEW_STATE, DDS.ALIVE_INSTANCE_STATE));

      --  Start polling all the readers in this thread.
      --  while getting errors as "interupts" in the listners.

      while Continue loop

         Ws.Wait (Conditions'Unchecked_Access, 1.00);

         for C of Conditions loop
            if Ada.Tags.Is_Descendant_At_Same_Level (C.all'Tag, DDS.ReadCondition.Ref'Tag) then
               Reader := DDS.ReadCondition.Ref_Access (C.all).Get_DataReader;
               Reader.Get_Listener.On_Data_Available (DDS.DataReaderListener.DataReader_Access (Reader));
            end if;
         end loop;
      end loop;

      --  Clean up the application
      Particpant.Delete_DataReader (StringReader1);
      Particpant.Delete_DataReader (StringReader2);
      Particpant.Delete_DataReader (OctetsReader1);
      Particpant.Delete_DataReader (OctetsReader2);

      Particpant.Delete_Topic (StringTopic1);
      Particpant.Delete_Topic (StringTopic2);
      Particpant.Delete_Topic (OctetsTopic1);
      Particpant.Delete_Topic (OctetsTopic2);
      Particpant.Delete_Contained_Entities;
      Factory.Delete_Participant (Particpant);

   end if;
end MultiReaderWaitset.Subscriber.Main;
