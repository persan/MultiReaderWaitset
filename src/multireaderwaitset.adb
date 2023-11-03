with System;
with Ada.Unchecked_Conversion;
with DDS.ReadCondition;
with DDS.ConditionSeq;
package body MultiReaderWaitset is

   ------------
   -- Attach --
   ------------

   not overriding procedure Attach
     (Self            : not null access Ref;
      Reader          : not null DDS.DataReader.Ref_Access;
      Sample_States   : in DDS.SampleStateMask;
      View_States     : in DDS.ViewStateMask;
      Instance_States : in DDS.InstanceStateMask;
      Listner         : not null DDS.DataReaderListener.Ref_Access)
   is
      Cond : DDS.ReadCondition.Ref_Access;
   begin
      Self.Map.Include (DDS.Entity.Ref_Access (Reader), DDS.Listener.Ref_Access (Listner));
      Cond := Reader.Create_Readcondition (Sample_States, View_States, Instance_States);
      Self.Attach_Condition (Cond);
   end Attach;

   not overriding procedure Attach (Self            : not null access Ref;
                                    Entity          : not null DDS.Entity.Ref_Access;
                                    Listner         : not null DDS.Listener.Ref_Access) is
   begin
      null;
   end;

   ----------
   -- Wait --
   ----------

   not overriding procedure Wait
     (Self : not null access Ref; Timeout : in DDS.Duration_T)
   is
      Active_Conditions : aliased DDS.ConditionSeq.Sequence;

   begin
      Self.Wait (Active_Conditions'Unchecked_Access, Timeout);
      for I of Active_Conditions loop
         if I.Get_Trigger_Value then
            if I'Class = DDS.DataReader.Ref'Class then
               declare
                  Reader : DDS.DataReader.Ref_Access := DDS.ReadCondition.Ref_Access (I).Get_DataReader;
                  Listner : DDS.DataReaderListener.Ref_Access := Reader.Get_Listener;
               begin
                  null;
               end;

            end if;
         end if;
      end loop;
   end Wait;

   function "<" (Left, Right : DDS.Entity.Ref_Access) return Boolean is
      use type System.Address;
      function As_Address is new Ada.Unchecked_Conversion (DDS.Entity.Ref_Access, System.Address);
   begin
      return As_Address (Left) < As_Address (Right);
   end;

   function "=" (Left, Right : DDS.Listener.Ref_Access) return Boolean is
   begin
      return DDS.Listener."=" (Left, Right);
   end;

end MultiReaderWaitset;
