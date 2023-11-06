with System; use System;
with Ada.Unchecked_Conversion;

package body DDS.Entity.Helpers is
   function As_Address is new Ada.Unchecked_Conversion (Ref_Access, System.Address);
   ---------
   -- "<" --
   ---------

   function "<" (Left, Right : Ref_Access) return Boolean is
   begin
      return As_Address (Left) < As_Address (Right);
   end "<";

   ---------
   -- "=" --
   ---------

   function "=" (Left, Right : Ref_Access) return Boolean is
   begin
      return As_Address (Left) = As_Address (Right);
   end "=";

end DDS.Entity.Helpers;
