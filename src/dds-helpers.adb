package body DDS.Helpers is

   -------------------------------
   -- Element_As_Octets_Generic --
   -------------------------------
   function Element_As_Octets_Generic (Item : aliased Element) return DDS.Octets is
   begin
      return Ret : DDS.Octets do
         Ret.Length := Item'Size / DDS.Octet'Size;
         Ret.Value := Item'Address;
      end return;
   end Element_As_Octets_Generic;
   -------------------------------
   -- Octets_As_Element_Generic --
   -------------------------------

   function Octets_As_Element_Generic
     (Item : aliased DDS.Octets) return Element
   is
      Ret : Element with Import => True, Address => Item.Value;
   begin
      raise Constraint_Error with "Length does not match Element" when
        Item.Length * Octet'Size /=  Element'Size;
      return Ret;
   end Octets_As_Element_Generic;

end DDS.Helpers;
