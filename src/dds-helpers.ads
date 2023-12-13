package DDS.Helpers is
   use type System.Address;
   generic
      type Element is private;
      pragma Compile_Time_Error (Element'Has_Access_Values, "Element may not contain pointers");
   function Element_As_Octets_Generic (Item : not null access constant Element) return DDS.Octets;
   --  Maps the element referenced by item direct to octets.
   -- ------------------------------------------------------------------------------------------

   generic
      type Element is private;
      pragma Compile_Time_Error (Element'Has_Access_Values, "Element may not contain pointers");
   function Octets_As_Element_Generic (Item : aliased DDS.Octets) return not null access Element
     with Pre => (Item.Length > 0 and then Item.Value /= System.Null_Address);

end DDS.Helpers;
