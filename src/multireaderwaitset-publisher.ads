with DDS.DomainParticipantFactory;
with DDS.DomainParticipant;
with DDS.Topic;
with DDS.String_DataWriter;
with DDS.Octets_DataWriter;

package MultiReaderWaitset.Publisher is

   Factory            : constant DDS.DomainParticipantFactory.Ref_Access := DDS.DomainParticipantFactory.Get_Instance;

   Particpant         : DDS.DomainParticipant.Ref_Access;

   StringTopic1       : DDS.Topic.Ref_Access;
   StringTopic2       : DDS.Topic.Ref_Access;
   OctetsTopic1       : DDS.Topic.Ref_Access;
   OctetsTopic2       : DDS.Topic.Ref_Access;

   StringWriter1 : DDS.String_DataWriter.Ref_Access;
   StringWriter2 : DDS.String_DataWriter.Ref_Access;

   OctetsWriter1 : DDS.Octets_DataWriter.Ref_Access;
   OctetsWriter2 : DDS.Octets_DataWriter.Ref_Access;

end MultiReaderWaitset.Publisher;
