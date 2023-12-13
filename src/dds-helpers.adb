package body DDS.Helpers is
   -------------------------------
   -- Element_As_Octets_Generic --
   -------------------------------
   function Element_As_Octets_Generic (Item : not null access constant Element) return DDS.Octets is
   begin
      return Ret : DDS.Octets do
         Ret.Length := Item'Size / DDS.Octet'Size;
         Ret.Value := Item.all'Address;
      end return;
   end Element_As_Octets_Generic;
   -------------------------------
   -- Octets_As_Element_Generic --
   -------------------------------

   function Octets_As_Element_Generic
     (Item : aliased DDS.Octets) return not null access Element
   is
      Ret : aliased Element with Import => True, Address => Item.Value;
   begin
      if Item.Length * Octet'Size /=  Element'Size then
         raise Constraint_Error with "Length does not match Element expected:" & Element'Object_Size'Image & ", got:"  & Integer (Item.Length * Octet'Size)'Image;
      end if;

      return Ret'Unrestricted_Access;
   end Octets_As_Element_Generic;

end DDS.Helpers;
