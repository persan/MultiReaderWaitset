with DDS.DataReaderListener.LogListners;
with DDS.DomainParticipantFactory;
with DDS.DomainParticipant;
with DDS.Topic;
with GNAT.Strings;
package MultiReaderWaitset.Subscriper is
   pragma Elaborate_Body;
   Factory            : constant DDS.DomainParticipantFactory.Ref_Access := DDS.DomainParticipantFactory.Get_Instance;
   Particpant         : DDS.DomainParticipant.Ref_Access;
   StringTopic1       : DDS.Topic.Ref_Access;
   StringTopic2       : DDS.Topic.Ref_Access;
   OctetsTopic1       : DDS.Topic.Ref_Access;
   OctetsTopic2       : DDS.Topic.Ref_Access;

   StringReader1 : DDS.DataReader.Ref_Access;
   StringReader2 : DDS.DataReader.Ref_Access;

   OctetsReader1 : DDS.DataReader.Ref_Access;
   OctetsReader2 : DDS.DataReader.Ref_Access;

   type Listner (Name : not null GNAT.Strings.String_Access) is new DDS.DataReaderListener.LogListners.Ref and MultiReader_Listner with null record;
   procedure On_Condition (Self      : not null access Listner;
                           Condition : aliased  DDS.Condition.Ref'Class);

   overriding procedure On_Data_Available
     (Self       : not null access Listner;
      The_Reader : in DDS.DataReaderListener.DataReader_Access);

   Ws            : MultiReaderWaitset.Ref;

   String1_Listner : aliased Listner (new String'("String1_Listner"));
   String2_Listner : aliased Listner (new String'("String2_Listner"));
   Octets1_Listner : aliased Listner (new String'("Octets1_Listner"));
   Octets2_Listner : aliased Listner (new String'("Octets2_Listner"));

end MultiReaderWaitset.Subscriper;
