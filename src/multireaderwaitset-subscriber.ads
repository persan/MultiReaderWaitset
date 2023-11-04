with DDS.DataReaderListener.LogListners;
with DDS.DomainParticipantFactory;
with DDS.DomainParticipant;
with DDS.Topic;
with GNAT.Strings;
with DDS.ReadCondition;
with DDS.DataReader;
with DDS.WaitSet;

package MultiReaderWaitset.Subscriber is

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

   type String_Server is limited interface;
   type String_Server_Access is not null access all String_Server'Class with Storage_Size => 0;
   procedure On_String (Self : not null access String_Server; Name : String; Data : DDS.String) is abstract;

   type Octets_Server is limited interface;
   type Octets_Server_Access is not null access all Octets_Server'Class with Storage_Size => 0;
   procedure On_Octets (Self : not null access Octets_Server; Name : String; Data : DDS.Octets) is abstract;

   task type Server_Type is new Octets_Server and String_Server with
      entry On_String (Name : String; Data : DDS.String);
      entry On_Octets (Name : String; Data : DDS.Octets);
      entry Close;
   end Server_Type;

   type String_Listner (Name   : not null GNAT.Strings.String_Access;
                        Server : String_Server_Access) is new DDS.DataReaderListener.LogListners.Ref with null record;

   type Octets_Listner (Name   : not null GNAT.Strings.String_Access;
                        Server : Octets_Server_Access) is new DDS.DataReaderListener.LogListners.Ref with null record;

   overriding procedure On_Data_Available
     (Self       : not null access String_Listner;
      The_Reader : in DDS.DataReaderListener.DataReader_Access);

   overriding procedure On_Data_Available
     (Self       : not null access Octets_Listner;
      The_Reader : in DDS.DataReaderListener.DataReader_Access);

   Ws              : aliased DDS.WaitSet.Ref;
   Server          : aliased Server_Type;
   Continue        : Boolean := True;

   String1_Listner : aliased String_Listner (new Standard.String'("String1_Listner"), Server'Access);
   String2_Listner : aliased String_Listner (new Standard.String'("String2_Listner"), Server'Access);
   Octets1_Listner : aliased Octets_Listner (new Standard.String'("Octets1_Listner"), Server'Access);
   Octets2_Listner : aliased Octets_Listner (new Standard.String'("Octets2_Listner"), Server'Access);

   String1_Condition : DDS.ReadCondition.Ref_Access;
   String2_Condition : DDS.ReadCondition.Ref_Access;
   Octets1_Condition : DDS.ReadCondition.Ref_Access;
   Octets2_Condition : DDS.ReadCondition.Ref_Access;

end MultiReaderWaitset.Subscriber;
