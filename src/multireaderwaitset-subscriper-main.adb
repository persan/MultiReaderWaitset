with Ada.Text_IO; use Ada.Text_IO;
with MultiReaderWaitset.Args;
with DDS.String_TypeSupport;
with DDS.Octets_TypeSupport;
with Dds.ConditionSeq;
with MultiReaderWaitset.Topic_Names; use MultiReaderWaitset.Topic_Names;
with GNAT.Ctrl_C;
with GNAT.Exception_Traces;
with GNAT.Traceback.Symbolic;
with Ada.Tags;
procedure MultiReaderWaitset.Subscriper.Main is
   Participant_QoS : DDS.DomainParticipantQos;
   Continue        : Boolean := True;
   procedure On_Ctrl_C is
   begin
      Continue := False;
      Ada.Text_Io.Standard_Output.Put_Line ("On <Ctrl-C>");
   end On_Ctrl_C;
   Conditions      : aliased Dds.ConditionSeq.Sequence;
begin
   if Args.Parser.Parse then
      GNAT.Exception_Traces.Trace_On (GNAT.Exception_Traces.Every_Raise);
      GNAT.Exception_Traces.Set_Trace_Decorator (GNAT.Traceback.Symbolic.Symbolic_Traceback_No_Hex'Access);
      GNAT.Ctrl_C.Install_Handler (On_Ctrl_C'Unrestricted_Access);
      Factory.Get_Default_Participant_Qos (Participant_QoS);
      Participant_QoS.Entity_Factory.Autoenable_Created_Entities := False;

      Particpant := Factory.Create_Participant (Args.DomainId.Get);

      StringTopic1 := Particpant.Create_Topic (Topic_Name => String1_Topic_Name, Type_Name => DDS.String_TypeSupport.Get_Type_Name);
      OctetsTopic1 := Particpant.Create_Topic (Topic_Name => Octets1_Topic_Name, Type_Name => DDS.Octets_TypeSupport.Get_Type_Name);
      StringTopic2 := Particpant.Create_Topic (Topic_Name => String2_Topic_Name, Type_Name => DDS.String_TypeSupport.Get_Type_Name);
      OctetsTopic2 := Particpant.Create_Topic (Topic_Name => Octets2_Topic_Name, Type_Name => DDS.Octets_TypeSupport.Get_Type_Name);

      --  Create the readers with a listner but no callbacke enabled.
      StringReader1 := Particpant.Create_DataReader (StringTopic1.As_TopicDescription, A_Listener => String1_Listner'Access);
      StringReader2 := Particpant.Create_DataReader (StringTopic2.As_TopicDescription, A_Listener => String2_Listner'Access);
      OctetsReader1 := Particpant.Create_DataReader (OctetsTopic1.As_TopicDescription, A_Listener => Octets1_Listner'Access);
      OctetsReader2 := Particpant.Create_DataReader (OctetsTopic2.As_TopicDescription, A_Listener => Octets2_Listner'Access);

      Ws.Attach_Condition (StringReader1.Create_Readcondition (DDS.NOT_READ_SAMPLE_STATE, DDS.ANY_VIEW_STATE, DDS.ALIVE_INSTANCE_STATE));
      Ws.Attach_Condition (StringReader2.Create_Readcondition (DDS.NOT_READ_SAMPLE_STATE, DDS.ANY_VIEW_STATE, DDS.ALIVE_INSTANCE_STATE));
      Ws.Attach_Condition (OctetsReader1.Create_Readcondition (DDS.NOT_READ_SAMPLE_STATE, DDS.ANY_VIEW_STATE, DDS.ALIVE_INSTANCE_STATE));
      Ws.Attach_Condition (OctetsReader2.Create_Readcondition (DDS.NOT_READ_SAMPLE_STATE, DDS.ANY_VIEW_STATE, DDS.ALIVE_INSTANCE_STATE));

      Particpant.Enable;

      while Continue loop
         begin
            Ws.Wait (Conditions'Unchecked_Access, 1.00);
         exception
            when DDS.TIMEOUT => null;
         end;
         for C of Conditions loop
            if Ada.Tags.Is_Descendant_At_Same_Level (C.all'Tag, DDS.ReadCondition.Ref'Tag) then
               put_line (Ada.Tags.External_Tag (C.all'Tag));
               declare
                  Reader : Dds.Datareader.Ref_Access;
                  Listner : DDS.DataReaderListener.Ref_Access;
                  CC      : constant DDS.ReadCondition.Ref_Access := DDS.ReadCondition.Ref_Access (C);
               begin

                  Reader := CC.Get_DataReader;
                  Listner := Reader.Get_Listener;
                  Listner.On_Data_Available (DDS.DataReaderListener.DataReader_Access (Reader));
               end;
            end if;
         end loop;
      end loop;

      Particpant.Delete_DataReader (StringReader1);
      Particpant.Delete_DataReader (StringReader2);
      Particpant.Delete_DataReader (OctetsReader1);
      Particpant.Delete_DataReader (OctetsReader2);

      Particpant.Delete_Topic (StringTopic1);
      Particpant.Delete_Topic (StringTopic2);
      Particpant.Delete_Topic (OctetsTopic1);
      Particpant.Delete_Topic (OctetsTopic2);
   end if;
end MultiReaderWaitset.Subscriper.Main;
