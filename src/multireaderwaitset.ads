with DDS.DataReader;
--  with DDS.DataReaderListener;
with DDS.Listener;
--  with DDS.DomainParticipantFactory;
--  with DDS.DomainParticipant;
--  with DDS.Topic;
--  with DDS.String_DataReader;
--  with DDS.Octets_DataReader;
with DDS.WaitSet;
with Ada.Containers.Ordered_Maps;
with DDS.Entity;
with DDS.Condition;
package MultiReaderWaitset is

   type Ref is new DDS.WaitSet.Ref with private;
   type MultiReader_Listner is limited interface;
   type MultiReader_Listner_Access is access all MultiReader_Listner'Class;

   procedure On_Condition (Self      : not null access MultiReader_Listner;
                           Condition : aliased  DDS.Condition.Ref'Class) is abstract;

   not overriding procedure Attach (Self            : not null access Ref;
                                    Reader          : not null DDS.DataReader.Ref_Access;
                                    Sample_States   : in DDS.SampleStateMask;
                                    View_States     : in DDS.ViewStateMask;
                                    Instance_States : in DDS.InstanceStateMask;
                                    Listner         : not null MultiReader_Listner_Access);

   not overriding procedure Attach (Self            : not null access Ref;
                                    Entity          : not null DDS.Entity.Ref_Access;
                                    Listner         : not null MultiReader_Listner_Access);

   not overriding procedure Wait (Self              : not null access Ref;
                                  Timeout           : in DDS.Duration_T);

private
   function "<" (Left, Right : DDS.Entity.Ref_Access) return Boolean;
   function "=" (Left, Right : DDS.Listener.Ref_Access) return Boolean;

   package Readermaps is new Ada.Containers.Ordered_Maps (Key_Type     => DDS.Entity.Ref_Access,
                                                          Element_Type => MultiReader_Listner_Access);

   type Ref is new DDS.WaitSet.Ref with record
      Map : Readermaps.Map;
   end record;

end MultiReaderWaitset;
